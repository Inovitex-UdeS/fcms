##
# Library for static methods to compare dates for edition limit dates (helpers for views)
module EditionsHelper

  ##
  # Return true if the end of registrations for the current edition has passed
  #
  # @return [Boolean]
  def isEndOfRegistrations?
    edition_id = Setting.find_by_key('current_edition_id').value
    edition = Edition.find(edition_id)
    return !(Time.now < edition.limit_date)
  end

  ##
  # Return true if the end of editing registrations for the current edition has passed
  #
  # @return [Boolean]
  def isEndOfEditRegistrations?
    edition_id = Setting.find_by_key('current_edition_id').value
    edition = Edition.find(edition_id)
    return !(Time.now < edition.edit_limit_date)
  end
end
