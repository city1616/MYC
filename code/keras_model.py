import librosa
import scipy.signal as signal
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
import numpy as np

x_train = []
y_train = []
chords = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'HC']
path = '/Users/seungwoomun/Documents/MYC/train/Grand Piano/'
paths = '/Users/seungwoomun/Documents/MYC/train/Grand Piano/C_1.wav'

# file_name = ["C_1.wav", "D_1.wav"]
# 도는 [1,0], 레는 [0,1]로 설정한다
lable = [[1, 0, 0, 0, 0, 0, 0, 0], # 도 C
        [0, 1, 0, 0, 0, 0, 0, 0],  # 레 D
        [0, 0, 1, 0, 0, 0, 0, 0],  # 미 E
        [0, 0, 0, 1, 0, 0, 0, 0],  # 파 F
        [0, 0, 0, 0, 1, 0, 0, 0],  # 솔 G
        [0, 0, 0, 0, 0, 1, 0, 0],  # 라 A
        [0, 0, 0, 0, 0, 0, 1, 0],  # 시 B
        [0, 0, 0, 0, 0, 0, 0, 1]]  # 도 HC

# train data 생성
for index in range(len(chords)):
    audio_sample, sampling_rate = librosa.load(path + chords[index] + '_1.wav', sr = 44100)
    input_data = np.abs(librosa.stft(audio_sample, n_fft = 2048, hop_length = 1024, win_length = 2048, window=signal.hann))
    
    # input_data의 배열 형태를 알아본다
    shape = np.shape(input_data)
    nb_samples = shape[0]
    nb_windows = shape[1]
    
    # [nb_samples][nb_windows] 형태이므로, 딥러닝을 수행하기 위한 배열 형태 [nb_windows][nb_samples]로 맞춰준다
    input_data = input_data.T
    
    # 학습용 레이블 배열을 생성한다
    lable_tmp = [lable[index] for row in range(nb_windows)]
    
    # 하나의 배열로 합친다    
    if index == 0:
        x_train = input_data
        y_train = lable_tmp
    else:
        x_train = np.r_[x_train, input_data]
        y_train = np.r_[y_train, lable_tmp]

# test data 생성
for indexs in range(len(chords)):
    audio_sample2, sampling_rate2 = librosa.load(path + chords[indexs] + '_3.wav', sr = 44100)
    input_data2 = np.abs(librosa.stft(audio_sample2, n_fft = 2048, hop_length = 1024, win_length = 2048, window=signal.hann))
    
    # input_data의 배열 형태를 알아본다
    shape2 = np.shape(input_data2)
    nb_samples2 = shape2[0]
    nb_windows2 = shape2[1]
    
    # [nb_samples][nb_windows] 형태이므로, 딥러닝을 수행하기 위한 배열 형태 [nb_windows][nb_samples]로 맞춰준다
    input_data2 = input_data2.T
    
    # 학습용 레이블 배열을 생성한다
    lable_tmp2 = [lable[indexs] for row in range(nb_windows2)]
    
    # 하나의 배열로 합친다    
    if indexs == 0:
        x_test = input_data2
        y_test = lable_tmp2
    else:
        x_test = np.r_[x_test, input_data2]
        y_test = np.r_[y_test, lable_tmp2]

# print(x_train.shape)
# print(y_train.shape)
# print(x_test.shape)
# print(y_test.shape)

# model 생성
model = Sequential()

model.add(Dense(units = 1025, input_dim = 1025)) # input_shape = (513, )
model.add(Dense(units = 128, activation = 'relu'))
model.add(Dense(8, activation = 'softmax'))
# model.add(Dense(128, activation = 'relu'))
# model.add(Dense(8, input_dim = 128, activation = 'relu'))
# model.add(Dense(1, activation = 'sigmoid'))

model.summary()

model.compile(optimizer = 'sgd', loss = 'mse', metrics = ['acc'])

# x_train = [[2, 4, 8], [3, 6, 9], [4, 8, 12]]
# y_train = [[2], [3], [4]]
# x_test = [[2, 4, 8]]

# 학습
model.fit(x_train, y_train, epochs = 500, verbose = 1, validation_data = (x_test, y_test)) # batch_size = 257

# 평가
print("#######  Model 평가  #######")
loss, acc = model.evaluate(x_test, y_test)
print("복원된 모델의 정확도: {:5.2f}%".format(100 * acc))

# 검증
print("#######  Model 검증  #######")
for i in range(255, 300) :
    test = np.array([x_test[i]])
    # print(test)
    print(model.predict(test))

# model 저장
# model.save('DNN_Model_2048_500.h5')

# W = tf.Variable(tf.random.normal([1]), name="weight")
# b = tf.Variable(tf.random.normal([1]), name="bias")

# hypothesis=x_train*W+b

# cost = tf.reduce_mean(tf.square(hypothesis - y_train))
# sgd = tf.keras.optimizers.SGD(learning_rate=0.01)

# model = Sequential()

# model.add(Dense(1, input_dim = 1))

# model.compile(loss='mean_squared_error',optimizer=sgd)

# model.fit(x_train,y_train,epochs=10)

# print(model.predict(np.array([5])))
