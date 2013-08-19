module BundlesHelper
  def has_access?(bundle)
    session[bundle.id].present? && session[bundle.id][:password].present?
  end

  def owner_for?(bundle)
    session[bundle.id].present? && session[bundle.id][:owner]
  end
end
