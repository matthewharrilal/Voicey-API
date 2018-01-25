# So what does serializers essentially do is enable us to specify what we want to render 


class MemoSerializer < ActiveModel::Serializer

  # These are the attributes that we want to render from the voice memo as oppose to any extra stuff that gets rendered with the json
  attributes :id, :title, :text_body, :time, :voice_file_url

  def voice_file_url
    object.voice_file.url()
  end
end

# Now our apps handles audio attachments