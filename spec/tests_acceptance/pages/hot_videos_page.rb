# frozen_string_literal: true

# Page object for hot videos page
class HotVideosPage
  include PageObject

  page_url YouTubeTrendingMap::App.config.APP_HOST + '/hot_videos'

  text_field(:country_name_input, id: 'country_name_input')
  # unordered_list(:select_category, xpath: "//div[@class='select-wrapper']/ul")
  select_list(:select_category, id: 'select_category')
  button(:search_button, id: 'search_btn')

  div(:error_message, id: 'modal_error')
  div(:reminder_message, id: 'reminder_card')
  list_item(:hot_videos_list, id: 'hot_videos_list')

  indexed_property(
    :hot_videos,
    [
      [:iframe, :embed_link,    { id: 'video[%s].embed_link' }],
      [:p,      :title,         { id: 'video[%s].title' }],
      [:p,      :channel_title, { id: 'video[%s].channel_title' }],
      [:span,   :view_count,    { id: 'video[%s].view_count' }]
    ]
  )

  def first_video
    hot_videos[0]
  end

  def first_video_li
    hot_videos_list_element.lis[0]
  end

  def first_video_play
    first_video_li.iframe.click
  end

  def num_videos
    hot_videos_list_element.lis - 1
  end

  def search_for_hot_videos(country_name, category)
    # self.country_name_input = country_name
    # self.select_category = category
    puts select_category
    puts select_category_options[1]
    value = select_category_options[1]
    self.select_category = value
    # wait_until(20) do
    #   self.select_category = select_category_options[1]
    # end
    search_button
  end
end
