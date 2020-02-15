class ProductFromUrlService
  def initialize(url:)
    @url = url
  end

  def call
    url_path = URI(@url).path
    product_identifier = url_path.split('/').last

    product = Product.find_or_initialize_by(
      provider_identifier: product_identifier,
      provider: :ikea,
    )

    return product if product.save

    nil
  end
end
