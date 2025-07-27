import Rating from "../ui/Rating";
import { useState } from "react";
import Modal from "../ui/Modal";
import ProductModal from "./ProductModal";
import ApiImage from "../ui/ApiImage";

function LinkCard({
  type,
  id,
  name,
  image,
  price,
  discount,
  stock,
  rating,
  categories,
  detailId
}) {
  // Fix: Handle discount as decimal (0.0 to 1.0) instead of percentage (0-100)
  const sale = discount > 0 ? price - (price * discount) : null; // Remove /100

  // handles Product Modal
  const [modalIsOpen, setModalIsOpen] = useState(false);

  const openModal = () => setModalIsOpen(true);
  const closeModal = () => setModalIsOpen(false);

  return (
    <>
      {/* Product Modal */}
      <Modal isOpen={modalIsOpen} onClose={closeModal}>
        <ProductModal id={detailId} type={type} />
      </Modal>
      <div className="relative group flex flex-col bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 overflow-hidden h-96">
        {/* Image Container */}
        <div className="relative h-56 overflow-hidden">
          <button onClick={openModal}>
            <ApiImage
              imageId={image}
              alt={name}
              className="object-cover h-full w-full transition-transform"
            />
          </button>

          {/* Discount Badge - Fix percentage display */}
          {discount > 0 && (
            <div className="absolute top-3 left-3 bg-gradient-to-r from-red-500 to-red-600 text-white px-3 py-1 rounded-full text-sm font-bold shadow-lg z-10">
              -{(discount * 100).toFixed(0)}% {/* Convert decimal to percentage for display */}
            </div>
          )}

          {/* Stock Status */}
          <div
            className={`absolute top-3 right-3 px-3 py-1 rounded-full text-xs font-semibold shadow-lg z-10 ${
              stock > 0
                ? "bg-green-100 text-green-800 border border-green-200"
                : "bg-red-100 text-red-800 border border-red-200"
            }`}
          >
            {stock > 0 ? `In Stock (${stock})` : "Out of Stock"}
          </div>

          {/* Overlay Gradient */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </div>

        {/* Content Container */}
        <div className="flex flex-col flex-1 p-4">
          {/* Product Name */}
          <h3 className="text-lg font-bold text-gray-800 mb-2 line-clamp-2 group-hover:text-sky-600 transition-colors duration-200">
            {name}
          </h3>

          {/* Product ID */}
          <p className="text-xs text-gray-500 mb-3">ID: #{id}</p>

          {/* Categories Tags */}
          {categories && categories.length > 0 && (
            <div className="flex flex-wrap gap-1 mb-3">
              {categories.slice(0, 3).map((category, index) => (
                <span
                  key={index}
                  className={`px-2 py-1 rounded-full text-xs font-medium transition-colors duration-200 ${
                    type === "equipment"
                      ? "bg-blue-100 text-blue-700 hover:bg-blue-200"
                      : "bg-purple-100 text-purple-700 hover:bg-purple-200"
                  }`}
                >
                  {category.charAt(0).toUpperCase() +
                    category.slice(1).replace("-", " ")}
                </span>
              ))}
              {categories.length > 3 && (
                <span className="px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-600">
                  +{categories.length - 3} more
                </span>
              )}
            </div>
          )}
          {/* Price Section */}
          <div className="flex items-center justify-between mb-4 mt-auto">
            <div className="flex flex-col">
              {sale ? (
                <>
                  <span className="text-xl font-bold text-sky-600">
                    ${sale.toFixed(2)}
                  </span>
                  <span className="text-sm text-gray-500 line-through">
                    ${price.toFixed(2)}
                  </span>
                </>
              ) : (
                <span className="text-xl font-bold text-gray-800">
                  {/* ${price.toFixed(2)} */}${price}
                </span>
              )}
            </div>

            {/* Type Badge */}
            <div
              className={`px-3 py-1 rounded-full text-xs font-medium ${
                type === "product"
                  ? "bg-sky-100 text-sky-800"
                  : "bg-purple-100 text-purple-800"
              }`}
            >
              {type === "equipment" ? "Equipment" : "Supplement"}
            </div>
          </div>
          {/* Rate */}
          <div>
            <Rating rating={rating} />
          </div>

          {/* Action Button */}
          <button
            className={`w-full py-3 text-center font-semibold rounded-xl transition-all duration-200 transform hover:scale-105 shadow-md ${
              stock > 0
                ? "bg-gradient-to-r from-sky-500 to-sky-600 hover:from-sky-600 hover:to-sky-700 text-white hover:shadow-lg"
                : "bg-gray-300 text-gray-500 cursor-not-allowed"
            }`}
            onClick={openModal}
          >
            {stock > 0 ? "Buy Now" : "Out of Stock"}
          </button>
        </div>

        {/* Hover Border Effect */}
        <div className="absolute inset-0 border-2 border-transparent group-hover:border-sky-400/50 rounded-2xl transition-all duration-300 pointer-events-none"></div>
      </div>
    </>
  );
}

export default LinkCard;
