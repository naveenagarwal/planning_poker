require 'test_helper'

class StoryPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story_point = story_points(:one)
  end

  test "should get index" do
    get story_points_url, as: :json
    assert_response :success
  end

  test "should create story_point" do
    assert_difference('StoryPoint.count') do
      post story_points_url, params: { story_point: { estimated_points: @story_point.estimated_points, estimated_time: @story_point.estimated_time, story_id: @story_point.story_id, user_id: @story_point.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show story_point" do
    get story_point_url(@story_point), as: :json
    assert_response :success
  end

  test "should update story_point" do
    patch story_point_url(@story_point), params: { story_point: { estimated_points: @story_point.estimated_points, estimated_time: @story_point.estimated_time, story_id: @story_point.story_id, user_id: @story_point.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy story_point" do
    assert_difference('StoryPoint.count', -1) do
      delete story_point_url(@story_point), as: :json
    end

    assert_response 204
  end
end
