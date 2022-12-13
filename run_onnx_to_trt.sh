ROOT_DIR=$(pwd)

######################################################
# Check model exists

if [ -f ./weights/yolov7.onnx ]; then
    echo "Start"
else
    echo "${ROOT_DIR}/weights/yolov7.onnx not exists"
    exit 0
fi

######################################################
# To trt

cd ${ROOT_DIR}

if [ -f ./weights/yolov7.trt ]; then
    echo "yolov7.trt exists, will skip .onnx to .trt part"
else
    echo "Start convert .onnx to .trt"
    cp ./weights/yolov7.onnx ./yolov7_onnx_to_trt/workspace/

    cd yolov7_onnx_to_trt

    rm -rf build
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)

    cd ../workspace
    ./pro

    rm -rf ./yolov7.onnx
    mv ./yolov7.FP32.trtmodel ${ROOT_DIR}/weights/yolov7.trt
fi

######################################################
# Use `yolov7.trt` and transfer `fast-reid_mobilenetv2.onnx` to `fast-reid_mobilenetv2.trt`

cd ${ROOT_DIR}

if [ -f ./weights/fast-reid_mobilenetv2.trt ]; then
    echo "fast-reid_mobilenetv2.trt exists, will skip fast-reid_mobilenetv2.onnx to fast-reid_mobilenetv2.trt part"
else
    cd yolov7_deepsort_tensorrt

    if [ ! -f ${ROOT_DIR}/weights/fast-reid_mobilenetv2.onnx ]; then
        rm -rf weights
        mkdir weights
        
        cd scripts
        bash get_weight.sh
        cd ..
        mv ./weights/fast-reid_mobilenetv2.onnx ${ROOT_DIR}/weights
    fi
    
    rm -rf build
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)

    cd ../scripts
    bash yolov7_deepsort.sh
fi

echo "Done."
echo "Export Path: ${ROOT_DIR}/weights"


