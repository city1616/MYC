import tensorflow as tf
import numpy as np
import librosa
import scipy.signal as signal
from operator import itemgetter
from pyknon.genmidi import Midi
from pyknon.music import NoteSeq, Note, Rest
import music21

filename = 'title.wav'

def print_pdf(filename) :
    chords = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'HC']
    path1 = '/Users/seungwoomun/Documents/MYC/train/Grand Piano/'
    path2 = '/Users/seungwoomun/Documents/MYC/train/Classical Grand/'
    path3 = '/Users/seungwoomun/Documents/MYC/train/test_wav/'
    path4 = '/Users/seungwoomun/Documents/MYC/train/Electric Piano/'
    path5 = '/Users/seungwoomun/Documents/MYC/code/wav/'
    lable = [[1, 0, 0, 0, 0, 0, 0, 0], # 도 C
            [0, 1, 0, 0, 0, 0, 0, 0],  # 레 D
            [0, 0, 1, 0, 0, 0, 0, 0],  # 미 E
            [0, 0, 0, 1, 0, 0, 0, 0],  # 파 F
            [0, 0, 0, 0, 1, 0, 0, 0],  # 솔 G
            [0, 0, 0, 0, 0, 1, 0, 0],  # 라 A
            [0, 0, 0, 0, 0, 0, 1, 0],  # 시 B
            [0, 0, 0, 0, 0, 0, 0, 1]]  # 도 HC
    test_pred = []
    test_result = []
    music = ''
    # filename = 'star_1.wav'

    # X, Y 데이터 추출
    audio_sample, sampling_rate = librosa.load(path5 + filename, sr = None)
    input_data = np.abs(librosa.stft(audio_sample, n_fft = 1024, hop_length = 512, win_length = 1024, window = signal.hann))

    filename = filename.replace('.wav',"")

    # input_data의 배열 형태를 알아본다
    shape = np.shape(input_data)
    nb_samples = shape[0]
    nb_windows = shape[1]

    # [nb_samples][nb_windows] 형태이므로, 딥러닝을 수행하기 위한 배열 형태 [nb_windows][nb_samples]로 맞춰준다
    input_data = input_data.T

    # 학습용 레이블 배열을 생성한다
    lable_tmp = [lable[0] for row in range(nb_windows)]

    # 하나의 배열로 합친다    

    x_test = np.array(input_data)
    y_test = np.array(lable_tmp)

    model = tf.keras.models.load_model("./DNN_Model_500.h5")

    print("#######  Model 평가  #######")
    loss, acc = model.evaluate(x_test, y_test)
    print("모델의 정확도: {:5.2f}%".format(100 * acc))


    prediction = model.predict(x_test)

    # 예측값에서 음계 구분
    for i in prediction :
        if i.argmax() == 0:
            test_pred.append("도")
            # test_pred = np.r_["도"]
        elif i.argmax() == 1 :
            test_pred.append("레")
            # test_pred = np.r_["레"]
        elif i.argmax() == 2 :
            test_pred.append("미")
            # test_pred = np.r_["미"]
        elif i.argmax() == 3 :
            test_pred.append("파")
            # test_pred = np.r_["파"]
        elif i.argmax() == 4 :
            test_pred.append("솔")
            # test_pred = np.r_["솔"]
        elif i.argmax() == 5 :
            test_pred.append("라")
            # test_pred = np.r_["라"]
        elif i.argmax() == 6 :
            test_pred.append("시")
            # test_pred = np.r_["시"]
        elif i.argmax() == 7 :
            test_pred.append("h_도")
            # test_pred = np.r_["h_도"]

    # 예측값에서 음계 개수 추출
    # print(test_pred)
    # print(len(test_pred))
    # print(test_pred[448])
    print(np.shape(test_pred))
    print("도 : " + str(test_pred.count("도")))
    print("레 : " + str(test_pred.count("레")))
    print("미 : " + str(test_pred.count("미")))
    print("파 : " + str(test_pred.count("파")))
    print("솔 : " + str(test_pred.count("솔")))
    print("라 : " + str(test_pred.count("라")))
    print("시 : " + str(test_pred.count("시")))
    print("h_도 : " + str(test_pred.count("h_도")))

    # 이전 음계 추출
    # for i in range(0, len(test_pred) - 1) :
    #     if test_pred[i] != test_pred[i + 1] :
    #         test_result.append(test_pred[i])
        
    #     if i + 1 == len(test_pred) - 1 :
    #         test_result.append(test_pred[i + 1])

    toc = 0
    # coc = 0
    # 최종 음계 추출
    for i in range(0, len(test_pred) - 1) :
        if test_pred[i] == test_pred[i + 1] :
            toc += 1
            # coc += 1
        else :
            toc = 0
            # coc = 0

        if toc >= 40 :    
            toc = 0
            test_result.append(test_pred[i])
        
        # if toc >= 40 and toc < 50 :    
        #     toc = 0
        #     if coc > 80 :
        #         coc = 0
        #     else :
        #         test_result.append(test_pred[i])

        # if toc >= 30 :
        #     toc = 0
        #     # test_result.append(test_pred[i])
        # elif toc >= 20 and toc < 25 :
        #     toc = 0
        #     test_result.append(test_pred[i])
                
    print(test_result)
    print(np.shape(test_result))
    print("음 개수 : " + str(len(test_result)))

    # midi file 생성
    notes = NoteSeq(music)

    # midi file 생성을 위한 구분
    for index in test_result :
        if index == '도' :
            # music = music + 'C4'
            notes.append(Note(12, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == '레' :
            # music = music + 'D4'
            notes.append(Note(14, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == '미' :
            # music = music + 'E4'
            notes.append(Note(16, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == '파' :
            # music = music + 'F4'
            notes.append(Note(17, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == '솔' :
            # music = music + 'G4'
            notes.append(Note(19, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == '라' :
            # music = music + 'A4'
            notes.append(Note(21, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == '시' :
            # music = music + 'B4'
            notes.append(Note(23, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        elif index == 'h_도' :
            # music = music + 'C4'
            notes.append(Note(24, octave = 4, dur = 1/4)) # 21 A 22 A# 23 B 24 C
        # music = music + ' '

    # notes.append(Note(24, octave = 4, dur = 1/8)) # 21 A 22 A# 23 B 24 C

    midi = Midi(number_tracks = 1, tempo = 90)
    midi.seq_notes(notes, track = 0)
    midi.write('Midi/' + filename + '.mid')

    # Midi to pdf
    us = music21.environment.UserSettings() # music21 환경 설정

    midi_file = music21.converter.parse('Midi/' + filename + '.mid')
    midi_file.insert(0, music21.metadata.Metadata())
    midi_file.metadata.title = 'Make Your Chord'
    midi_file.metadata.composer = 'MYC'
    midi_file.write('musicxml.pdf', fp = 'pdf/'+ filename + '.pdf')
    print(midi_file)
    # index, value = max(enumerate(prediction[0]), key = itemgetter(1))
    # print(index, value)

    # # for i in x_test :

    # 검증
    # print("#######  Model 검증  #######")
    # for i in range(0, len(x_test)) :
    #     test = np.array([x_test[i]])
    #     # print(test)
    #     print(model.predict(test))

print_pdf(filename)