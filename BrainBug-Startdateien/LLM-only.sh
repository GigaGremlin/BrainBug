#!/bin/bash
echo "--- Starte KI-System Vorbereitung (Ollama Edition) ---"
# 1. Desktop stoppen und RAM leeren (Essentiell für Orin Nano 8GB) 
systemctl stop gdm || systemctl stop gdm3 
sync && echo 3 | tee /proc/sys/vm/drop_caches 
echo "RAM wurde optimiert."
# 2. Alte Container aufräumen 
echo "Bereinige alte Container..." 
docker rm -f ollama-jetson open-webui 2>/dev/null
echo "--- Starte Ollama Server (Optimiert für Home Assistant) ---"
# 3. Ollama mit NUM_PARALLEL=2 für Stabilität bei vielen Automatisierungen 
docker run -d \
--name ollama-jetson \
--runtime nvidia \
--network host \
-v ollama_data:/root/.ollama \
# Nur eine Instanz vorhalten, nicht mehr 2 !!
-e OLLAMA_NUM_PARALLEL=1 \
-e OLLAMA_KEEP_ALIVE=-1 \
-e OLLAMA_HOST=0.0.0.0:11434 \
-e OLLAMA_ORIGINS="*" \
ollama/ollama:latest
echo "Warte 15 Sekunden auf Initialisierung..." 
sleep 15
# 4. Das Modell vorladen (Damit BrainBug sofort bereit ist) 
echo "Lade Modell Llama 3.2 in den VRAM..." 
# Hier ist das -d entfernen und der Text geändert
docker exec ollama-jetson ollama run llama3.2:3b "Antworte nur mit einem Punkt."
# 5. WebUI Sektion (DEAKTIVIERT - Zeilen mit # am Anfang werden ignoriert)
# echo "--- Starte Open WebUI ---" 
# docker run -d --name open-webui --network=host \
# -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
# --add-host=host.docker.internal:host-gateway \
# ghcr.io/open-webui/open-webui:main
echo "--- FERTIG ---"
echo "Ollama läuft mit NUM_PARALLEL=2. WebUI bleibt entladen." 
echo "Nutze 'docker logs -f ollama-jetson' um den Status zu sehen."
