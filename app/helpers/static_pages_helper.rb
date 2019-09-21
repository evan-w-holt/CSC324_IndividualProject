module StaticPagesHelper
  def get_vowel_img(letter, html_class)
    unless letter.nil?
      return image_tag("#{letter}.png", class: html_class)
    end
  end
end
