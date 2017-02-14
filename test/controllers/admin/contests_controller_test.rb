require 'test_helper'

class Admin::ContestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_contest = admin_contests(:one)
  end

  test "should get index" do
    get admin_contests_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_contest_url
    assert_response :success
  end

  test "should create admin_contest" do
    assert_difference('Admin::Contest.count') do
      post admin_contests_url, params: { admin_contest: { description_en: @admin_contest.description_en, description_ja: @admin_contest.description_ja, end_at: @admin_contest.end_at, name_en: @admin_contest.name_en, name_ja: @admin_contest.name_ja, score_baseline: @admin_contest.score_baseline, start_at: @admin_contest.start_at } }
    end

    assert_redirected_to admin_contest_url(Admin::Contest.last)
  end

  test "should show admin_contest" do
    get admin_contest_url(@admin_contest)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_contest_url(@admin_contest)
    assert_response :success
  end

  test "should update admin_contest" do
    patch admin_contest_url(@admin_contest), params: { admin_contest: { description_en: @admin_contest.description_en, description_ja: @admin_contest.description_ja, end_at: @admin_contest.end_at, name_en: @admin_contest.name_en, name_ja: @admin_contest.name_ja, score_baseline: @admin_contest.score_baseline, start_at: @admin_contest.start_at } }
    assert_redirected_to admin_contest_url(@admin_contest)
  end

  test "should destroy admin_contest" do
    assert_difference('Admin::Contest.count', -1) do
      delete admin_contest_url(@admin_contest)
    end

    assert_redirected_to admin_contests_url
  end
end
