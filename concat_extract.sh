set -eux

img="/search/odin/sxf/data/pirender/host_img/*.png"
video="/search/odin/sxf/data/pirender/test_video/256_*.mp4"
concat_video="/search/odin/sxf/data/pirender/concat_video/test/"

mkdir -p $concat_video

#rename '#' 'x' *

for i in $img
do
    ffmpeg -i $i -pix_fmt yuv420p -y tmp.mp4
    f_i=`echo $i | cut -d"." -f1 | rev | cut -d"/" -f1 | rev`
    for j in $video
    do
        f_j=`echo $j | cut -d"." -f1 | rev | cut -d"/" -f1 | rev`
        echo "file tmp.mp4" >tmp
        echo "file "$j >>tmp
        ffmpeg -f concat -safe 0 -i tmp -y -c copy $concat_video"/"$f_i"_"$f_j".mp4"
        rm tmp -f
    done
    rm tmp.mp4 -f
done
#exit


video="/search/odin/sxf/data/pirender/concat_video/"
keypoint="/search/odin/sxf/data/pirender/concat_video_keypoint/"
coef="/search/odin/sxf/data/pirender/concat_video_3dmm/"

mkdir -p $keypoint
mkdir -p $coef

python extract_kp_videos.py --input_dir $video --output_dir $keypoint --device_ids 0,1,2,3 --workers 12

python face_recon_videos.py --input_dir $video --keypoint_dir $keypoint --output_dir $coef --inference_batch_size 600 --name=model_name --epoch=20 --model facerecon  #--gpu_ids=0,1,2,3

