# SWDDPole - Smart Wildlife Detection & Deterrent Pole

SWDDPole is a wildlife monitoring and deterrent system designed to detect elephants near protected areas and send real-time updates to a Firebase backend. The system combines computer vision using YOLOv5 (night model) and YOLOv8 (day model) with a Raspberry Pi-based sensor and camera setup.

---

## Project Structure
```markdown
SWDDPole/
├── ui_code/ # Frontend application (Flutter/web) for monitoring
├── yolo_elephant_detection/ # YOLO models and detection scripts
│ ├── my_model.pt # YOLOv8 daytime model weights
│ ├── nv_elephant.pt # YOLOv5 nighttime model weights
│ └── ... # Additional YOLOv5/YOLOv8 scripts and files
├── shell.py # Main Raspberry Pi script for camera, sensors, and detection
└── README.md # Project documentation
---
```

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

---

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
(Create a `requirements.txt` file with the following Python dependencies: `torch`, `opencv-python`, `ultralytics`, `firebase-admin`, `gpiozero`.)

3. **Place Firebase Credentials Safely:**

(Copy your Firebase service account JSON file to the root of the project, e.g., `wildguardsentinel.json`.)

>⚠️ Important: Do not commit this file to GitHub.

4. **Run the Detection Script:**
```bash
python shell.py
```
* The system will wait for motion via the PIR sensor.
* It will use the day or night YOLO model depending on the light sensor reading.
* Detected elephants are counted and sent to Firestore in real time.

---

## Security & Secrets

* `wildguardsentinel.json` contains your Firebase credentials. Never commit this file to GitHub.
* Add it to your `.gitignore`:

```bash
# Firebase credentials
wildguardsentinel.json
```

* API keys in `firebase_options.dart` (if using Flutter frontend) are not secret, but sensitive credentials like service accounts must be kept private.

---

## Notes

* YOLOv8 model is used for **daytime** detection.
* YOLOv5 model is used for **nighttime** detection.
* GPIO simulation is available on laptops if `gpiozero` is not installed.
* The script overlays the model type and elephant count on the camera feed.

---

## References

- [Ultralytics YOLOv8](https://github.com/ultralytics/ultralytics)
- [YOLOv5](https://github.com/ultralytics/yolov5)  
- [Firebase Admin SDK for Python](https://firebase.google.com/docs/admin/setup)  
- [gpiozero Documentation](https://gpiozero.readthedocs.io/en/stable/)

---

## License
MIT License (or your chosen license)
