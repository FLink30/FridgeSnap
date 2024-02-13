import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        // Foto + Name + Brand /////////////////////////
        VStack(alignment: .leading, spacing: 8) {
            // Foto  /////////////////////////
            if let imageUrl = URL(string: product.imageUrlBig), !product.imageUrlBig.isEmpty {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .background(Color.gray.opacity(Padding.opacitySmall()))
                            .frame(width: Padding.fotoBig(), height: Padding.fotoBig())
                            .cornerRadius(Padding.medium())
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: Padding.fotoBig(), height: Padding.fotoBig())
                            .cornerRadius(Padding.medium())
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: Padding.itemWidth(), height: Padding.itemWidth())
                            .cornerRadius(Padding.medium())
                    @unknown default:
                        fatalError()
                    }
                }
            } else {
                // Placeholder image when imageUrl is empty or invalid //////////////
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: Padding.fotoBig(), height: Padding.fotoBig())
                    .cornerRadius(Padding.medium())
                
            }
            // Name + Brand  /////////////////////////
            VStack(alignment: .leading, spacing: Padding.small()) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(product.brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(Padding.medium())
            
            Spacer()
        }
    }
}


#Preview {
    let sampleProduct = Product.MOCK_Product_empty
    return ProductDetailView(product: sampleProduct)
}
