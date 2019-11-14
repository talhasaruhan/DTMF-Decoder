delete(instrfindall);
clear;
clc;

%%
% Set DTMF configurations
DTMF_COLS = [1209 1336 1477 1633];
DTMF_ROWS = [697 770 852 941];
DTMF = [['1', '2', '3', 'A'], ['4', '5', '6', 'B'], ['7', '8', '9', 'C'], ['*', '0', '#', 'D']];
DTMF = reshape(DTMF, [4, 4])';

%%
% Set the configuration.
port = "COM6";
baudrate = 115200;
N = 500;
signedbyte = "int8";
byte = "uint8";
INVALID = 0xFF;
ESTABLISH_SAMPLING_RATE_REQUEST_FLAG = 0xFE;
ESTABLISH_SAMPLING_RATE_ACK_FLAG = 0xFD;
ESTABLISH_SAMPLING_RATE_START_DATA_FLAG = 0xFC;
ESTABLISH_SAMPLING_RATE_END_DATA_FLAG = 0xFB;
READ_ANALOG_INPUT_REQUEST_FLAG = 0xFA;
READ_ANALOG_INPUT_ACK_FLAG = 0xEF;
READ_ANALOG_INPUT_DONE_FLAG = 0xEE;

ESTABLISH_SAMPLING_RATE_NUM_TESTS = 10;
ESTABLISH_SAMPLING_RATE_NUM_SAMPLES = 100;
READ_ANALOG_INPUT_WINDOW_LENGTH = 100e-3; % Window length in ms
DTMF_DELTA_LIMIT = 100;

%%
% Open the serial port.
s = serialport(port, baudrate);

%%
% Test the connection
TestSerialConnection(s, INVALID);

%%
% Establish sampling rate
sampling_freq = EstablishSamplingRate(s, ...
    INVALID, ESTABLISH_SAMPLING_RATE_REQUEST_FLAG, ESTABLISH_SAMPLING_RATE_ACK_FLAG, ...
    ESTABLISH_SAMPLING_RATE_START_DATA_FLAG, ESTABLISH_SAMPLING_RATE_END_DATA_FLAG, ...
    ESTABLISH_SAMPLING_RATE_NUM_TESTS, ESTABLISH_SAMPLING_RATE_NUM_SAMPLES);

%%
% Parse DTMF over the serial
FetchAndParseDTMFOnline(s, sampling_freq, READ_ANALOG_INPUT_WINDOW_LENGTH, DTMF_DELTA_LIMIT, DTMF, INVALID, ...
    READ_ANALOG_INPUT_REQUEST_FLAG, READ_ANALOG_INPUT_ACK_FLAG, READ_ANALOG_INPUT_DONE_FLAG);

