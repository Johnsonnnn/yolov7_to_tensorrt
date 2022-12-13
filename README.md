# yolov7_to_tensorrt

## Requirement

* **TensorRT**
* **CUDA**
* **CUDNN**
* **OpenCV**

### 1. Install Dependency
```bash
install_python_dependency.sh
install_ubuntu_dependency.sh
```

## Prepare
### 1. Modify
1. `yolov7_onnx_to_trt/src/main.cpp` in line 23
```cpp
// Modify to your labels
static const char* cocolabels[] = {
    "car", "cat", "dog"
}
```

2. `yolov7_onnx_to_trt/CMakeLists.txt` in line 11
```bash
# set the corresponding CUDA arch
set(CUDA_GEN_CODE "-gencode=arch=compute_61,code=sm_61")
```

3. `yolov7_deepsort_tensorrt/configs/config_v7.yaml` in line 4 and 21
```bash
# Set your labels file path
labels_file:   "../configs/coco.names" 
```

### 2. Put `yolov7.pt` or `yolov7.onnx` to `yolov7_to_tensorrt/weights`
* Make sure the model name is `yolov7.pt` or `yolov7.onnx`

## Usage
```bash
git clone https://github.com/Johnsonnnn/yolov7_to_tensorrt.git
```

### `.pt` to `.trt`
```bash
cd yolov7_to_tensorrt
bash run_pt_to_trt.sh
```

### `.onnx` to `.trt`
```bash
cd yolov7_to_tensorrt
bash run_onnx_to_trt.sh
```


## This project merges parts of other Github projects
1. https://github.com/shouxieai/tensorRT_Pro
2. https://github.com/xuarehere/yolov7_deepsort_tensorrt
3. https://github.com/WongKinYiu/yolov7
