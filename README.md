# 🧠 Project: BrainBug 2026
### Local AI Power for Home Assistant & ESPHome
---

<div align="center">
<img width="960" alt="BrainBug-2026-Header" src="https://github.com/user-attachments/assets/5f680f64-5c75-4f3a-b6e1-26645630168d" />

[![Status](https://img.shields.io/badge/Status-In--Development-orange?style=for-the-badge)](https://gigagremlin.de/brainbug-2026)
[![Hardware](https://img.shields.io/badge/Hardware-NVIDIA%20Jetson%20Orin%20Nano-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](https://www.nvidia.com/de-de/autonomous-machines/embedded-systems/jetson-orin/)
</div>

---

## 📌 Das Konzept<br>
Da ich für mein Home Assistant und die verbundenen **Voice Assistenten** gerne eine
lokale Ki nutzen wollte, ist dieses Projekt entstanden.<br>
**BrainBug** ist als KI-Zentrale für mein Smart Home gedacht. <br>Dank des **NVIDIA Jetson Orin Nano** und moderner **LLM Modelle** ist es möglich High-End Performance auf lokaler Hardware zu realisieren.<br><br> **Update:** BrainBug läuft jetzt mit **Ternary-Bonsai-8B.gguf**

---

<div align="center">
  <img width="44%" alt="20260422_small" src="https://github.com/user-attachments/assets/21b7497a-10cf-4335-8f1d-a733c6affaa8" />
  <img width="40%" alt="20260422_small2" src="https://github.com/user-attachments/assets/2ee28d09-5d3a-4ce1-8ec4-ee3df2104ba0" />
</div>


---


## 🚀 Warum lokal? (Der "Nanny-Filter" & Cloud-Fehler)<br>
Die Cloud-Lösung von Nabu Casa neigt in meinem Netz zu Fehlern: `Media reader encountered an error: ESP_FAIL`. 
**BrainBug** eliminiert diese Latenz und umgeht unnötige Filterfunktionen, die nur Rechenleistung fressen.


---


## 📘 Dokumentation & Setup<br>
Natürlich ist meine Version nicht bloß die nackte Platine, welche von einer TF-Speicherkarte gebootet wird. 
Ich habe mir die Mühe gemacht den NANO mit einer 1TB NVMe auszurüsten und diese bootfähig zu machen.
Da der Aufbau einer Ki mit nur 8GB gelinde gesagt eine sportliche Herausforderung ist, setze ich für die Zukunft, auf die neuen **1Bit Modelle** die jetzt gerade erscheinen und eine phänomenale Performance bei geringstem VRAM-Bedarf realisieren!<br>Ich nur empfehlen die ersten Gehversuche mit einer TF-Speicherkarte und einer Größe ab **64GB** zu beginnen! Da eine **bootfähige** Speicherkarte einfacher wieder herzustellen ist als die NVMe. Bei mir hat es 8 Versuche gebraucht, bis ich eine Brauchbare Lösung hatte. Ich habe zunächst verschiedene LLM-Modelle ausprobiert, bin aber immer wieder an der Sprachbarriere und Kompatibilität mit Home Assistant gescheitert. Die Open WebUi habe ich zu Gunsten von **AnythingLLM** wieder abgeschaltet, genau wie den **Ubuntu Desktop** da ich so den extra Container und Arbeitsspeicher sparen kann. Gerne hätte ich einfach eine “unzensierte“ LLM Version verwendet, da diese nicht erst jede Anfrage durch ihre Sicherheitsfilter überprüfen muss. Die Leute verstehen scheinbar nicht wieviel Zeit für diesen Mist verlorengeht und wie groß der extra Rechenaufwand für eine **Nanni-Funktion** ist! <br> Leider gibt es aber nicht viele Modelle die sich gut für die Home Assistant Integration eignen, unzensiert sind und Deutsch sprechen.<br>
Da sich durch die **Updateflut** von HA seit einigen Wochen **alles was an TTS & STT über HA Cloud** läuft, permanent verschlechtert, habe ich mich dazu entschlossen meinen Jetson Nano diese Funktion ebenfalls erfüllen zu lassen!<br>**Und ja, das geht!** - Weil in meiner Konfiguration **TTS und STT, nur über die CPU und nicht im VRAM** laufen! Daher ist der momentane Stand, für den regulären Betrieb, bei meinem Gerät **Ollama3.2:3b + STT & TTS** in einem Docker Container.<br>

Wer mag kann sich meine verschiedenen Versionen hier ansehen und selber ausprobieren.<br>
<br>

<img width="1431" height="883" alt="DockerTTS (1)" src="https://github.com/user-attachments/assets/c0668110-d313-4fec-8a30-a7553ddab429" /><br>

<br><br>

<img width="1428" height="879" alt="J-Top (1)" src="https://github.com/user-attachments/assets/6a92a33a-c912-4f95-91bc-36461bcb0fe1" /><br>

<br><br>
## 🔥👍👍👍  Meine aktuelle Konfiguration & klare Empfehlung<br>
...ist die Verwendung des 'Ternary-Bonsai-8B-gguf'❗ Wie man auf dem Screenshot gut sehen kann verbraucht es sogar weniger Recourcen 
als mein altes Llama 3.2:3b und das für ein 8B Modell, welches normalerweise den VRAM sprengen würde‼️<br>
Hier ist der Hugging Face-Link für das 1.58Bit Modell: (https://huggingface.co/prism-ml/Ternary-Bonsai-8B-gguf/) <br>
Der einzige Wermutstropfen bei der Sache ist, dass es die Installation von Lama.cpp, zum laden des Modells, erfordert. <br>
Womit das Ternary-Bonsai-8B dann auch **nicht** in einem Doker Container läuft. <br> Doch das Ergebnis ist den Aufwand wert😁 

<br>
<img width="1400" height="800" alt="Ternary-Bonsai-8B (1 58-bit)" src="https://github.com/user-attachments/assets/140e9872-1262-40c6-8f47-cc11b712c117" />
<!-- > <img width="817" height="512" alt="Ternary-Bonsai-8B (1 58-bit)" src="https://github.com/user-attachments/assets/140e9872-1262-40c6-8f47-cc11b712c117" /> -->

<br><br>
---
## 🛠 Konfigurations-Archiv (Firmware & YAMLs)
*Hier findest Du alle aktuellen und vergangenen Versionen. Wähle die passende Konfiguration für Dein Setup:*

| Version | Typ | Modell / Engine | Download |
| :--- | :--- | :--- | :--- |
| **v1.0** | 🧠 Pure Brain | Llama 3.2:3b für XL Kontextfenster | [📦 LLM-only.sh](BrainBug-Startdateien/LLM-only.sh) |
| **v1.1** | 🎙 Full Voice | Llama 3.2 + Whisper & Piper | [📦 LLM-TTS-STT.sh](BrainBug-Startdateien/LLM-TTS-STT.sh) |
| **v2.0** | 🚀 1.58-Bit Model | **Prism ML- LLM + Whisper & Piper + XL Kontextfenster** | [📦 LLM-TTS-STT.sh](BrainBug-Startdateien/TBonsai8B-TTS-STT.sh) |

<!-- > **Neu:** Du hast ein neues Modell gefunden? Einfach eine neue Zeile in der Tabelle oben einfügen!-->

---

## 📺 Media & Tutorials
YouTube Video folgt...

<!--[![YouTube Video](https://img.shields.io/badge/YouTube-Video--Tutorial-red?style=for-the-badge&logo=youtube&logoColor=white)](HIER_DEINEN_YOUTUBE_LINK_EINSETZEN)   -->


---

## 🔗 Community & Links
👉 **[Gibt es natürlich ebenfalls als Ki-Projekt auf gigagremlin.de / gigagremlin.com](https://gigagremlin.de/brainbug-2026)**

---

<div align="center">
<i>Zuletzt aktualisiert: April 2026</i>
</div>

</div></div>   
<div align="center">
   <a href="https://gigagremlin.de">
    <img src="https://img.shields.io/badge/Made%20by-GigaGremlin-blue?style=for-the-badge" alt="GigaGremlin Website" />
  </a>
</div>
