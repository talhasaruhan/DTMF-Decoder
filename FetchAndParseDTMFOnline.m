function FetchAndParseDTMFOnline(s, sampling_freq, READ_ANALOG_INPUT_WINDOW_LENGTH, DTMF_DELTA_LIMIT, DTMF, INVALID, ...
    READ_ANALOG_INPUT_REQUEST_FLAG, READ_ANALOG_INPUT_ACK_FLAG, READ_ANALOG_INPUT_DONE_FLAG)

prevcode = 0;
while 1
    code = FetchAndParseSingleDTMFCode(s, sampling_freq, READ_ANALOG_INPUT_WINDOW_LENGTH, DTMF_DELTA_LIMIT, ...
        DTMF, INVALID, READ_ANALOG_INPUT_REQUEST_FLAG, READ_ANALOG_INPUT_ACK_FLAG, READ_ANALOG_INPUT_DONE_FLAG);
    if code ~= prevcode
        if code ~= 0
            disp(code);
        end
        prevcode = code;
    end
end

end

