require 'test_helper'

class SprintsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sprint = sprints(:one)
  end

  test "should get index" do
    get sprints_url, as: :json
    assert_response :success
  end

  test "should create sprint" do
    assert_difference('Sprint.count') do
      post sprints_url, params: { sprint: { name: @sprint.name, references: @sprint.references } }, as: :json
    end

    assert_response 201
  end

  test "should show sprint" do
    get sprint_url(@sprint), as: :json
    assert_response :success
  end

  test "should update sprint" do
    patch sprint_url(@sprint), params: { sprint: { name: @sprint.name, references: @sprint.references } }, as: :json
    assert_response 200
  end

  test "should destroy sprint" do
    assert_difference('Sprint.count', -1) do
      delete sprint_url(@sprint), as: :json
    end

    assert_response 204
  end
end
