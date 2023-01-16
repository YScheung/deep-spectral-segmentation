# Example parameters for the semantic segmentation experiments
DATASET="VOC2012"
MODEL="dino_vits16"
MATRIX="laplacian"
DOWNSAMPLE=16
N_SEG=10
N_ERODE=2
N_DILATE=5
'''
# Feature Extraction
python3 extract.py extract_features \
    --images_list "./data/VOC2012/lists/images.txt" \
    --images_root "./data/VOC2012/images" \
    --output_dir "./data/VOC2012/features/dino_vits16" \
    --model_name dino_vits16 \
    --batch_size 1

# Eigenvector Computation
python3 extract.py extract_eigs \
    --images_root "./data/VOC2012/images" \
    --features_dir "./data/VOC2012/features/dino_vits16" \
    --which_matrix "laplacian" \
    --output_dir "./data/VOC2012/eigs/laplacian" \
    --K 5

# Extract segments
python extract.py extract_multi_region_segmentations \
    --non_adaptive_num_segments ${N_SEG} \
    --features_dir "./data/${DATASET}/features/${MODEL}" \
    --eigs_dir "./data/${DATASET}/eigs/${MATRIX}" \
    --output_dir "./data/${DATASET}/multi_region_segmentation/${MATRIX}"

# Extract bounding boxes
python extract.py extract_bboxes \
    --features_dir "./data/${DATASET}/features/${MODEL}" \
    --segmentations_dir "./data/${DATASET}/multi_region_segmentation/${MATRIX}" \
    --num_erode ${N_ERODE} \
    --num_dilate ${N_DILATE} \
    --downsample_factor ${DOWNSAMPLE} \
    --output_file "./data/${DATASET}/multi_region_bboxes/${MATRIX}/bboxes.pth"

# Extract bounding box features
python extract.py extract_bbox_features \
    --model_name ${MODEL} \
    --images_root "./data/${DATASET}/images" \
    --bbox_file "./data/${DATASET}/multi_region_bboxes/${MATRIX}/bboxes.pth" \
    --output_file "./data/${DATASET}/multi_region_bboxes/${MATRIX}/bbox_features.pth"

# Extract clusters
python extract.py extract_bbox_clusters \
    --bbox_features_file "./data/${DATASET}/multi_region_bboxes/${MATRIX}/bbox_features.pth" \
    --output_file "./data/${DATASET}/multi_region_bboxes/${MATRIX}/bbox_clusters.pth" 

# Create semantic segmentations
python extract.py extract_semantic_segmentations \
    --segmentations_dir "./data/${DATASET}/multi_region_segmentation/${MATRIX}" \
    --bbox_clusters_file "./data/${DATASET}/multi_region_bboxes/${MATRIX}/bbox_clusters.pth" \
    --output_dir "./data/${DATASET}/semantic_segmentations/patches/${MATRIX}/segmaps" 
'''
python extract.py extract_crf_segmentations \
    --images_list "./data/VOC2012/lists/images.txt" \
    --images_root "./data/VOC2012/images" \
    --segmentations_dir "./data/${DATASET}/multi_region_segmentation/${MATRIX}"  \
    --output_dir "./data/${DATASET}/semantic_segmentations/patches/${MATRIX}/crf-segmaps" \
