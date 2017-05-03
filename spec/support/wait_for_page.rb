module WaitForPage
  def wait_for_page(text: nil, dom_finder: nil)
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests? && text_visible?(text) && element_visible?(dom_finder)
    end
  end

  # use this method if #finished_all_ajax_requests? bugs out
  def wait_for_dom(dom_finder: nil)
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until element_visible?(dom_finder)
    end
  end

  # use this method if #finished_all_ajax_requests? bugs out
  def wait_for_text(text)
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until text_visible?(text)
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def text_visible?(text)
    if text
      expect_to_see(text)
    else
      true
    end
  rescue RSpec::Expectations::ExpectationNotMetError => e
    false
  end

  def element_visible?(dom_finder)
    if dom_finder
      !!page.find(dom_finder)
    else
      true
    end
  rescue Capybara::ElementNotFound => e
    false
  end
end
