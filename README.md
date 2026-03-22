# SWDDPole - Smart Wildlife Detection & Deterrent Pole

SWDDPole is a wildlife monitoring and deterrent system designed to detect elephants near protected areas and send real-time updates to a Firebase backend. The system combines computer vision using YOLOv5 (night model) and YOLOv8 (day model) with a Raspberry Pi-based sensor and camera setup.

---

## Project Structure
SWDDPole/
├── ui_code/ # Frontend application (Flutter/web) for monitoring
├── yolo_elephant_detection/ # YOLO models and detection scripts
│ ├── my_model.pt # YOLOv8 daytime model weights
│ ├── nv_elephant.pt # YOLOv5 nighttime model weights
│ └── ... # Additional YOLOv5/YOLOv8 scripts and files
├── shell.py # Main Raspberry Pi script for camera, sensors, and detection
└── README.md # Project documentation
---

## Getting Started

### Requirements

- Python 3.9+
- OpenCV
- PyTorch
- Ultralytics YOLO (YOLOv8)
- YOLOv5 repository (local)
- gpiozero (for Raspberry Pi GPIO)
- Firebase Admin SDK
- Raspberry Pi (or computer for testing)

### Installation

1. **Clone the repository:**

```bash
git clone <your-repo-url>
cd SWDDPole
```
2. **Install Python dependencies:**
```bash
pip install -r requirements.txt
```
(Create a requirements.txt file with the following Python dependencies: torch, opencv-python, ultralytics, firebase-admin, gpiozero.)

3. **Place Firebase Credentials Safely:**

Copy your Firebase service account JSON file to the root of the project, e.g., wildguardsentinel.json.

⚠️ Important: Do not commit this file to GitHub.

4. **Run the Detection Script:**
```bash
python shell.py
```

The system waits for motion via the PIR sensor.
Uses YOLOv8 for daytime or YOLOv5 for nighttime depending on the light sensor.
Detected elephants are counted and sent to Firestore in real-time.
Annotated video feed shows the model type and elephant count.

Security & Secrets
wildguardsentinel.json contains your Firebase credentials. Never commit this file to GitHub.
Add the file to your .gitignore:
# Firebase credentials
wildguardsentinel.json
API keys in firebase_options.dart (for Flutter frontend) are not secret. Only service account JSON files must be kept private.
Notes
YOLOv8 is used for daytime detection.
YOLOv5 is used for nighttime detection.
GPIO simulation is available if gpiozero is not installed (useful for laptop testing).
Camera feed overlays which model is active and the number of detected elephants.

References
Ultralytics YOLOv8
YOLOv5
Firebase Admin SDK for Python
gpiozero Documentation
License

MIT License (or choose your preferred license)
