module EditionsHelper
  def isEndOfRegistrations?
    edition_id = Setting.find_by_key('current_edition_id').value
    edition = Edition.find(edition_id)
    return (Time.now < edition.limit_date)
  end
end
