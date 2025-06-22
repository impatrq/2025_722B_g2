#include <Wire.h>
#include <MPU6050.h>
#include <AS5600.h>

// Define pins for I2C
#define SDA_PIN 21
#define SCL_PIN 22

MPU6050 mpu;
AS5600 as5600;

void printMPU6050Data() {
  sensors_event_t accel, gyro, temp;
  mpu.getEvent(&accel, &gyro, &temp);

  Serial.print("Accel X: ");
  Serial.print(accel.acceleration.x, 2);
  Serial.print(" m/s² | Gyro Z: ");
  Serial.print(gyro.gyro.z, 2);
  Serial.print(" rad/s");
}

void printAS5600Data() {
  float angle = as5600.getAngle();
  Serial.print(" | Angle: ");
  Serial.print(angle, 2);
  Serial.println("°");
}

void checkSensors() {
  // MPU6050
  if (!mpu.begin()) {
    Serial.println("❌ MPU6050 not found! Check wiring.");
    while (true);  // halt
  } else {
    Serial.println("✅ MPU6050 ready");
  }

  // AS5600
  if (!as5600.begin()) {
    Serial.println("❌ AS5600 not found! Check wiring.");
    while (true);  // halt
  } else {
    Serial.println("✅ AS5600 ready");
  }
}

void setup() {
  Serial.begin(115200);
  delay(500); 

  Wire.begin(SDA_PIN, SCL_PIN);
  Serial.println("🔍 Initializing sensors...");
  checkSensors();
}

void loop() {
  printMPU6050Data();
  printAS5600Data();
  delay(200);
}