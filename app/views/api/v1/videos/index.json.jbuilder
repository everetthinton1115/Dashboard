json.message "success"
json.success true
json.videos @videos.each do |video|
  json.id video.id
  json.title video.title
  json.description video.description
  json.status video.status
  json.video_url video.video.url
  json.user_id video.user_id
  json.user_name video.user.name
  json.user_image_url video.user.identification_photo.url
end