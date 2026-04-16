#!/bin/bash
echo "--- Starte KI-System Vorbereitung (Jetson Orin Nano 8GB) ---"
# 1. Desktop stoppen und RAM leeren
systemctl stop gdm || systemctl stop gdm3 
sync && echo 3 | tee /proc/sys/vm/drop_caches 
echo "RAM wurde optimiert."
# 2. Alte Container aufräumen
echo "Bereinige Instanzen..." 
docker rm -f ollama-jetson GG-Whisper GG-Piper 2>/dev/null
echo "--- Starte Ollama Server ---"
# 3. Ollama Start (Optimiert für 8GB VRAM)
docker run -d \
--name ollama-jetson \
--runtime nvidia \
--network host \
-v ollama_data:/root/.ollama \
-e OLLAMA_NUM_PARALLEL=1 \
-e OLLAMA_KEEP_ALIVE=-1 \
-e OLLAMA_HOST=0.0.0.0:11434 \
-e OLLAMA_ORIGINS="*" \
ollama/ollama:latest
echo "Starte GG-Whisper (STT) auf Port 10300..."
# 4. Whisper (STT) auf CPU mit eindeutigem Namen für HA
docker run -d \
--name GG-Whisper \
--network host \
--restart unless-stopped \
-v wyoming-whisper-gg-data:/data \
rhasspy/wyoming-whisper:latest \
--model base \
--language de \
--uri tcp://0.0.0.0:10300
echo "--- Starte GG-Piper auf Port 10200..."
# 5. Piper mit eindeutigem Namen für HA
docker run -d \
--name GG-Piper \
--network host \
--restart unless-stopped \
-v wyoming-piper-gg-data:/data \
rhasspy/wyoming-piper:latest \
--voice de_DE-thorsten-high \
--uri tcp://0.0.0.0:10200
echo "Warte 15 Sekunden auf Initialisierung..." 
sleep 15
# 6. Modell vorladen
echo "Lade Modell Llama 3.2 in den VRAM..." 
docker exec -d ollama-jetson ollama run llama3.2:3b "Hallo, ich bin jetzt fertig mit laden"
echo "--- FERTIG ---"
echo "Ollama: 11434 | Whisper: 10300 | Piper: 10200"
echo "Nutze 'docker logs -f ollama-jetson' oder 'docker ps' zur Kontrolle."