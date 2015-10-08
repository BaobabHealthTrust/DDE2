module ApplicationHelper

  def version_tag
    `git describe`
  end

end
