module InterestingChecker

  def is_matching_some_regex(string, regex)
    match = string.match regex
    (match ? true : false)
  end
  def is_crazy_good?(string)
    is_matching_some_regex string, /Crazy|crazy|Knaller|Amazing|amazing|!{2,}/
  end

  def is_potential_error_fare?(string)
    is_matching_some_regex string, /EF|Error|mistake|Mistake/
  end

  def is_urgent?(string)
    is_matching_some_regex string, /schnell|quick|warten|urgent|fast/
  end

  def has_good_cpm?(string)
    match = string.match /(\d|\d\.\d).?(cpm|CPM|Cpm)/
    (match and match[1].to_f < 4.0 ? true : false)
  end

  def is_interesting?(string)
    false || has_good_cpm?(string) || is_crazy_good?(string) || is_potential_error_fare?(string)
  end
end