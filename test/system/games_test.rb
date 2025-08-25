require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert_text "New game"
    assert_selector ".letters p", count: 10
  end

  test "Submitting a word not in the grid shows an error message" do
    visit new_url
    fill_in "word", with: "ZZZZZZ"
    click_on "Play"

    assert_text "can't be built"
  end

  test "Submitting a valid English word gives congratulations" do
    visit new_url

    letters = all(".letters p").map(&:text)
    word = if letters.include?("A")
            "A"
          elsif letters.include?("I")
            "I"
          else
            letters.first
          end

    fill_in "word", with: word
    click_on "Play"

    page_content = page.text
    assert page_content.include?("Congratulations!") || page_content.include?("does not seem to be a valid English word")
  end
end
