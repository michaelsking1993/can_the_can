require 'test_helper'

class BaseWordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @base_word = base_words(:one)
  end

  test "should get index" do
    get base_words_url
    assert_response :success
  end

  test "should get new" do
    get new_base_word_url
    assert_response :success
  end

  test "should create base_word" do
    assert_difference('BaseWord.count') do
      post base_words_url, params: { base_word: { base_word: @base_word.base_word, frequency: @base_word.frequency, language_id: @base_word.language_id, pos_id: @base_word.pos_id } }
    end

    assert_redirected_to base_word_url(BaseWord.last)
  end

  test "should show base_word" do
    get base_word_url(@base_word)
    assert_response :success
  end

  test "should get edit" do
    get edit_base_word_url(@base_word)
    assert_response :success
  end

  test "should update base_word" do
    patch base_word_url(@base_word), params: { base_word: { base_word: @base_word.base_word, frequency: @base_word.frequency, language_id: @base_word.language_id, pos_id: @base_word.pos_id } }
    assert_redirected_to base_word_url(@base_word)
  end

  test "should destroy base_word" do
    assert_difference('BaseWord.count', -1) do
      delete base_word_url(@base_word)
    end

    assert_redirected_to base_words_url
  end
end
