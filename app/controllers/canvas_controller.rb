class CanvasController < ApplicationController
  def draw
  end

  # Convert base64 to binary
def split_base64(uri_str)
  if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
    uri = Hash.new
    uri[:type] = $1 # "image/gif"
    uri[:encoder] = $2 # "base64"
    uri[:data] = $3 # data string
    uri[:extension] = $1.split('/')[1] # "gif"
    return uri
  else
    return nil
  end
end

# Convert data uri to uploaded file. Expects object hash, eg: params[:profile_image]
def convert_data_uri_to_upload(obj_hash)
  if obj_hash[:remote_image_url].try(:match, %r{^data:(.*?);(.*?),(.*)$})
    image_data = split_base64(obj_hash[:remote_image_url])
    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)

    temp_img_file = Tempfile.new("data_uri-upload")
    temp_img_file.binmode
    temp_img_file << image_data_binary
    temp_img_file.rewind

    img_params = {:filename => "data-uri-img.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
    uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

    obj_hash[:image] = uploaded_file
    obj_hash.delete(:remote_image_url)
  end

  return obj_hash    
end


def create
  @profile_image           = ProfileImage.new(convert_data_uri_to_upload(params[:profile_image]))
  @profile_image.imageable = @imageable

  respond_to do |format|
    if @profile_image.save
      format.html { redirect_to @entity_redirect_edit_path, notice: 'Profile image was successfully created.' }
      format.json { render json: @profile_image, status: :created, location: @profile_image }
    else
      format.html { render action: "new" }
      format.json { render json: @profile_image.errors, status: :unprocessable_entity }
    end
  end
end


end

