class Memo < ApplicationRecord
    # So what is happening in this class many memos belong to one user and we know it is a to one relationship due to the fact that we have put belongs to user 
    belongs_to :user

    # What this essentially means that if the user has these properties present in the creation the memo then they are going to be accepted but doesnt require to have these
    # can have less but not more essentially or else it will not validate it
    validates :title, :date, :text_body, :user, presence: true
    has_attached_file :voice_file
    validates_attachment :voice_file, content_type: { content_type: ['audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio']}
  end