#!/bin/bash
echo "Skript gestartet am: $(date)" >> /home/GG/debug_start.log
# Das entzieht Docker die Grundlage, den Container neu zu erstellen
docker rmi ollama/ollama:latest
# --- Home Assistant Einstellungen ---   <-- Optional
# 1. Log-Bereinigung   <-- Optional

# 2. RADIKALER CLEANUP (Zuerst Platz schaffen, damit lsof nicht blockiert)
# Wir beenden ALLES, was den Port 11434 belegen könnte, BEVOR wir warten
docker stop ollama-jetson 2>/dev/null
docker rm -f ollama-jetson 2>/dev/null
sudo fuser -k 11434/tcp 2>/dev/null
sleep 2

# 3. DIE WARTESCHLEIFE (Prüft, ob der Cleanup erfolgreich war)
echo "Warte auf finale Netzwerk-Freigabe..."
while sudo lsof -i :11434; do
    echo "System räumt Port 11434 noch auf... bitte warten."
    sudo fuser -k 11434/tcp 2>/dev/null
    sleep 2
done
echo "Port 11434 ist FREI." >> /home/GG/ki_status.log

# 4. Desktop stoppen für max. VRAM (Wichtig für Jetson!)
sudo systemctl stop gdm
sudo loginctl terminate-seat seat0
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches

# 5. Whisper & GGper sauber neu starten
docker rm -f GG-Whisper GG-GGper 2>/dev/null
echo "Starte Audio-Dienste (Whisper/GGper)..."
docker run -d --name GG-Whisper --network host --restart unless-stopped -v wyoming-whisper-gg-data:/data rhasspy/wyoming-whisper:latest --model base --language de --uri tcp://0.0.0.0:10300
docker run -d --name GG-GGper --network host --restart unless-stopped -v wyoming-GGper-gg-data:/data rhasspy/wyoming-GGper:latest --voice de_DE-thorsten-high --uri tcp://0.0.0.0:10200

# --- AB HIER STARTET DIE SCHLEIFE FÜR DEN LLAMA-SERVER ---
while true; do
    # 6. Log-Bereinigung    <-- Optional, gehört bei mir zu 1.

    # 7. RADIKALER CLEANUP 
    pkill -9 llama-server 2>/dev/null
    sudo fuser -k 11434/tcp 2>/dev/null
    sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
    sleep 2

    # 8. DIE WARTESCHLEIFE (Prüft Port-Freigabe)
    while sudo lsof -i :11434; do
        echo "System räumt Port 11434 noch auf..."
        sudo fuser -k 11434/tcp 2>/dev/null
        sleep 2
    done
    echo "Port 11434 ist FREI." >> /home/GG/ki_status.log

	# 9. Status-Update an Home Assistant
	curl -X POST -H "Authorization: Bearer $HA_TOKEN" -H "Content-Type: application/json" -d '{"state": "Bonsai-Server wird gestartet"}' "http://$HA_IP:8123/aGG/states/$HA_ENTITY" > /dev/null 2>&1

	# 10. Native llama-server (Bonsai) starten
	pkill -9 llama-server 2>/dev/null
	sleep 2
	echo "Starte Ternary-Bonsai auf GPU..."
	nohup /home/GG/llama.cpp/build/bin/llama-server \
	  -m /home/GG/models/Ternary-Bonsai-8B-Q2_0.gguf \
	  --n-gpu-layers 99 \
	  --ctx-size 8192 \
	  --host 0.0.0.0 \
	  --port 11434 > /home/GG/llama_server.log 2>&1 &

	echo "--- SYSTEM BEREIT ---" >> /home/GG/ki_status.log
	echo "tail -f /home/GG/llama_server.log <--> und <--> zum beenden tail -f"

	# Pause bis zum nächsten automatischen Aufräumen
	sleep 1200
done