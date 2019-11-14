#define SERIAL_BAUDRATE 115200
#define ANALOG_GND_LVL 512

#define INVALID_REQUEST 0xFF
#define ESTABLISH_SAMPLING_RATE_REQUEST_FLAG 0xFE
#define ESTABLISH_SAMPLING_RATE_ACK_FLAG 0xFD
#define ESTABLISH_SAMPLING_RATE_START_DATA_FLAG 0xFC
#define ESTABLISH_SAMPLING_RATE_END_DATA_FLAG 0xFB
#define READ_ANALOG_INPUT_REQUEST_FLAG 0xFA
#define READ_ANALOG_INPUT_ACK_FLAG 0xEF
#define READ_ANALOG_INPUT_DONE_FLAG 0xEE

void setup() {
  Serial.begin(SERIAL_BAUDRATE);
}

void WaitForSerialInput() {
  while(!Serial.available()) {}
}

void PrintU16(uint16_t v){
  char buf[10];
  itoa(v, buf, 10);
  Serial.println(buf);
}

uint32_t SerialReadU32() {
  uint32_t v = 0;
  WaitForSerialInput();
  uint8_t t0 = Serial.read();
  WaitForSerialInput();
  uint8_t t1 = Serial.read();
  WaitForSerialInput();
  uint8_t t2 = Serial.read();
  WaitForSerialInput();
  uint8_t t3 = Serial.read();
  v = ((uint32_t)t0 << 24) || ((uint32_t)t1 << 16) || ((uint16_t)t2 << 8) || (uint16_t)t3;
  return v;
}

uint16_t SerialReadU16() {
  uint16_t v = 0;
  WaitForSerialInput();
  uint8_t t0 = Serial.read();
  WaitForSerialInput();
  uint8_t t1 = Serial.read();
  v = ((uint16_t)t0 << 8);
  v |= (uint16_t)t1;
  return v;
}

void SerialWriteU32(uint32_t val) {
  for (uint8_t j = 0; j < 32; j += 8) {
    Serial.write((val >> j) & 0xFF);
  }
}

void SerialWriteU16(uint16_t val) {
  Serial.write((uint8_t)(val & 0xFF));
  Serial.write((uint8_t)(val >> 8));
}

void SampleSingle() {
  int sensor_val = (int)analogRead(A0) - ANALOG_GND_LVL;
  sensor_val *= 2;
  if (sensor_val < 0) {
    if (sensor_val < -120) {
      sensor_val = -120;
    }
    sensor_val = -1 * sensor_val;
    uint8_t val = sensor_val;
    Serial.write(val + 128);
  } else {
    if (sensor_val > 120) {
      sensor_val = 120;
    }
    Serial.write((uint8_t)sensor_val);
  }
}

void Sample() {
  Serial.write(READ_ANALOG_INPUT_ACK_FLAG);
  uint16_t n = SerialReadU16();
  SerialWriteU16(n);
  for (uint16_t i = 0; i < n; ++i) {
    SampleSingle();
  }
  Serial.write(READ_ANALOG_INPUT_DONE_FLAG);
}

void EstablishSamplingRate(uint8_t num_tests, uint8_t num_samples) {
  Serial.write(ESTABLISH_SAMPLING_RATE_ACK_FLAG);
  uint32_t t0;
  uint32_t t1;
  uint32_t tests[255];
  t0 = micros();
  for (uint8_t t = 0; t < num_tests; ++t) {
    for (int i = 0; i < num_samples; ++i) {
      SampleSingle();
    }
    t1 = micros();
    tests[t] = t1;
  }
  Serial.write(ESTABLISH_SAMPLING_RATE_START_DATA_FLAG);
  Serial.write(num_tests);
  Serial.write(num_samples);
  SerialWriteU32(t0);
  for (uint8_t i = 0; i < num_tests; ++i) {
    SerialWriteU32(tests[i]);
  }
  Serial.write(ESTABLISH_SAMPLING_RATE_END_DATA_FLAG);
}

void EstablishSamplingRate() {
  WaitForSerialInput();
  uint8_t num_tests = Serial.read();
  WaitForSerialInput();
  uint8_t num_samples = Serial.read();
  Serial.write(num_tests);
  Serial.write(num_samples);
  EstablishSamplingRate(num_tests, num_samples);
}

void loop() {
  WaitForSerialInput();
  uint8_t flag = Serial.read();
  switch (flag) {
    case ESTABLISH_SAMPLING_RATE_REQUEST_FLAG:
      EstablishSamplingRate();
      break;
    case READ_ANALOG_INPUT_REQUEST_FLAG:
      Sample();
      break;
    default:
      Serial.write(INVALID_REQUEST);
      Serial.write(flag);
      break;
  }
}
