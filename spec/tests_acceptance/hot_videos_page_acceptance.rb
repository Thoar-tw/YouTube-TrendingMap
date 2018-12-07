# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/hot_videos_page.rb'

describe 'Hot Videos Page Acceptance Tests' do
  include PageObject::PageFactory

  DatabaseHelper.setup_database_cleaner

  before do
    DatabaseHelper.wipe_database
    @browser = Watir::Browser.new
    @headless = Headless.new
  end

  after do
    @browser.close
    @headless.destroy
  end

  # describe 'Visit Hot Videos Page' do
  #   it '(HAPPY) should not see videos list if has not searched for hot videos before' do
  #     # GIVEN: user has not got a videos list in hot_videos page before
  #     # WHEN: they visit the hot_videos page
  #     visit HotVideosPage do |page|
  #       # THEN: they should see empty input field, no videos list, and a reminder message
  #       _(page.hot_videos_list_element.exist?).must_equal false
  #       _(page.country_name_input).must_equal ''

  #       _(page.reminder_message_element.exists?).must_equal true
  #       _(page.reminder_message.downcase).must_include 'reminder'
  #     end
  #   end

  #   # it '(HAPPY) should not see projects they did not request' do
  #   #   # GIVEN: a project exists in the database but user has not requested it
  #   #   project = CodePraise::Github::ProjectMapper
  #   #     .new(GITHUB_TOKEN)
  #   #     .find(USERNAME, PROJECT_NAME)
  #   #   CodePraise::Repository::For.entity(project).create(project)

  #   #   # WHEN: user goes to the homepage
  #   #   visit HomePage do |page|
  #   #     # THEN: they should not see any projects
  #   #     _(page.projects_table_element.exists?).must_equal false
  #   #   end
  #   # end
  # end

  describe 'Search for Hot Videos' do
    it '(HAPPY) should be able to search by Typing Name or Clicking on Map' do
      # GIVEN: user is on the home page without any projects
      visit HotVideosPage do |page|
        # @browser.select_list(id: 'select_category').option(value: '0').wait_until(&:present?)
        # WHEN: they search for Taiwan's hot videos with default video category and submit
        page.search_for_hot_videos(COUNTRY_NAME, 'All')
        # @browser.element(:xpath, "//div[@class='input-field']/div[@class='select-wrapper']/ul/li[2]").click

        # THEN: they should see a hot videos list on the left, while the reminder message disappears
        _(page.hot_videos_list_element.exist?).must_equal true
        _(page.reminder_message_element.exists?).must_equal false
      end
    end

    # it '(HAPPY) should be able to see requested projects listed' do
    #   # GIVEN: user has requested a project
    #   visit HomePage do |page|
    #     good_url = "https://github.com/#{USERNAME}/#{PROJECT_NAME}"
    #     page.add_new_project(good_url)
    #   end

    #   # WHEN: they return to the home page
    #   visit HomePage do |page|
    #     # THEN: they should see their project's details listed
    #     _(page.projects_table_element.exists?).must_equal true
    #     _(page.num_projects).must_equal 1
    #     _(page.first_project.text).must_include USERNAME
    #     _(page.first_project.text).must_include PROJECT_NAME
    #   end
    # end

  #   it '(HAPPY) should see project highlighted when they hover over it' do
  #     # GIVEN: user has requested a project to watch
  #     good_url = "https://github.com/#{USERNAME}/#{PROJECT_NAME}"
  #     visit HomePage do |page|
  #       page.add_new_project(good_url)
  #     end

  #     # WHEN: they go to the home page
  #     visit HomePage do |page|
  #       # WHEN: ..and hover over their new project
  #       page.first_project_hover

  #       # THEN: the new project should get highlighted
  #       _(page.first_project_highlighted?).must_equal true
  #     end
  #   end

    it '(BAD) should not be able to search by an invalid country name' do
      # GIVEN: user is on the home page without any projects
      visit HotVideosPage do |page|
        # WHEN: they request a project with an invalid URL
        bad_country_name = 'taipei'
        page.search_for_hot_videos(bad_country_name, 'All')

        # THEN: they should see a warning message
        _(page.error_message.downcase).must_include 'error'
      end
    end

  #   it '(SAD) should not be able to add valid but non-existent project URL' do
  #     # GIVEN: user is on the home page without any projects
  #     visit HomePage do |page|
  #       # WHEN: they add a project URL that is valid but non-existent
  #       sad_url = "https://github.com/#{USERNAME}/foobar"
  #       page.add_new_project(sad_url)

  #       # THEN: they should see a warning message
  #       _(page.warning_message.downcase).must_include 'could not find'
  #     end
  #   end
  end

  # describe 'Delete Project' do
  #   it '(HAPPY) should be able to delete a requested project' do
  #     # GIVEN: user has requested and created a project
  #     visit HomePage do |page|
  #       good_url = "https://github.com/#{USERNAME}/#{PROJECT_NAME}"
  #       page.add_new_project(good_url)
  #     end

  #     # WHEN: they revisit the homepage and delete the project
  #     visit HomePage do |page|
  #       page.first_project_delete

  #       # THEN: they should not find any projects
  #       _(page.projects_table_element.exists?).must_equal false
  #     end
  #   end
  # end
end
