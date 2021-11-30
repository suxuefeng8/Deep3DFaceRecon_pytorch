set -eux

video="/search/odin/sxf/data/voxceleb/vox2/"
keypoint="/search/odin/sxf/data/voxceleb/keypoint2/"
coef="/search/odin/sxf/data/voxceleb/3dmm2"

python extract_kp_videos.py --input_dir $video --output_dir $keypoint --device_ids 0,1,2,3 --workers 12

python face_recon_videos.py --input_dir $video --keypoint_dir $keypoint --output_dir $coef --inference_batch_size 600 --name=model_name --epoch=20 --model facerecon  #--gpu_ids=0,1,2,3

