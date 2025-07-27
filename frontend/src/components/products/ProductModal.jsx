import React, { useEffect, useState } from "react";
import useCartStore from "../../stores/useCartStore";
import Rating from "../ui/Rating";
import {
  getEquipmentById,
  getSupplementById,
} from "../../services/productService";
import ApiImage from "../ui/ApiImage";
import { useNotification } from "../ui/Notification";
import { useNavigate } from "react-router-dom";

function ProductModal({ type, id }) {
  const [detail, setDetail] = useState({});
  const [quantity, setQuantity] = useState(1);
  const { addToCart } = useCartStore();
  const { showNotification, NotificationContainer } = useNotification();
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        let result;
        if (type === "equipment") {
          result = await getEquipmentById(id);
          setDetail(result.data);
        } else if (type === "supplement") {
          result = await getSupplementById(id);
          setDetail(result.data);
        }
      } catch (error) {
        console.error("Error fetching product details:", error);
      }
    };

    if (id) {
      fetchData();
    }
  }, [type, id]);

  // Extract product data from nested structure
  const product = detail?.product || {};
  const promotion = detail?.promotion;
  const supplier = detail?.supplier;
  const categoryNames = detail?.categoryNames || [];
  const price = product.price || 0;

  const discount = promotion?.discountOverride || 0;
  const discountedPrice =
    promotion && discount > 0
      ? price - (price * discount)
      : null;

  // Check if promotion is active
  const isPromotionActive = promotion
    ? new Date() >= new Date(promotion.startDate * 1000) &&
      new Date() <= new Date(promotion.endDate * 1000)
    : false;

  const currentPrice =
    isPromotionActive && discountedPrice ? discountedPrice : price;

  // Handle quantity change
  const handleQuantityChange = (change) => {
    const newQuantity = quantity + change;
    const stock = product.stock || 0;
    if (newQuantity >= 1 && newQuantity <= stock) {
      setQuantity(newQuantity);
    }
  };

  // Handle add to cart
  const handleAddToCart = () => {
    if (product.stock > 0) {
      const image = product.image || null;
      const cartItem = {
        id: product.id,
        name: product.name,
        price: currentPrice,
        quantity: quantity,
        image: image,
        type: type,
        stock: product.stock,
        originalPrice: price,
        discount: discount,
      };
      addToCart(cartItem, quantity);
      showActionNotification();
    }
  };

  // Show notification with action buttons
  const showActionNotification = () => {
    const message = (
      <div className="flex flex-col space-y-3">
        <div className="flex items-center">
          <span className="font-medium">
            {quantity}x {product.name}
          </span>{" "}
          added to cart!
        </div>
        <div className="flex items-center space-x-3 pt-2">
          <button
            onClick={() => navigate("/user/checkout")}
            className="px-3 py-1 bg-white/30 hover:bg-white/40 rounded-md text-sm font-medium transition"
          >
            Checkout
          </button>
          <button
            onClick={() => navigate("/products")}
            className="px-3 py-1 bg-white/20 hover:bg-white/30 rounded-md text-sm transition"
          >
            Continue Shopping
          </button>
        </div>
      </div>
    );
    showNotification(message, "success", 8000);
  };

  const parseIngredients = (ingredientString) => {
    if (!ingredientString) return [];
    try {
      const cleaned = ingredientString.replace(/^"|"$/g, "");
      return cleaned.split(",").map((item) => item.trim());
    } catch {
      return [ingredientString];
    }
  };

  return (
    <>
      <NotificationContainer />
      <div className="flex flex-col p-6 m-3 space-y-10 bg-white rounded-2xl shadow-2xl md:flex-row md:space-y-0 md:space-x-10 md:m-0 md:p-16 max-w-4xl">
        {/* Image */}
        <div className="flex-shrink-0">
          <ApiImage
            imageId={product.image}
            alt={product.name}
            className="mx-auto duration-200 w-80 h-80 object-cover rounded-lg hover:scale-105"
          />
        </div>
        {/* Content */}
        <div className="flex flex-col space-y-6 flex-1">
          <div className="flex flex-col mb-4 space-y-3 text-center md:text-left">
            <div className="max-w-lg text-2xl font-medium text-gray-800">
              {product.name}
            </div>
            <div className="text-sm text-gray-500">
              Product ID: {product.id}
            </div>
            <div className="text-gray-600 text-sm max-w-lg">
              {product.description}
            </div>
            {/* Product Details */}
            <div
              className={`grid grid-cols-2 gap-4 p-4 ${
                type === "equipment" ? "bg-gray-50" : "bg-purple-50"
              } rounded-lg`}
            >
              {/* Size */}
              <div>
                <span className="text-sm font-medium text-gray-700">Size:</span>
                <p className="text-sm text-gray-600">
                  {detail?.size === 1
                    ? "Small"
                    : detail.size === 2
                    ? "Medium"
                    : detail.size === 3
                    ? "Large"
                    : "N/A"}
                </p>
              </div>
              {/* Color (equipment only) */}
              {type === "equipment" && detail.color && (
                <div>
                  <span className="text-sm font-medium text-gray-700">Color:</span>
                  <p className="text-sm text-gray-600">{detail.color}</p>
                </div>
              )}
              {/* Gender (equipment only) */}
              {type === "equipment" && detail.gender && (
                <div>
                  <span className="text-sm font-medium text-gray-700">Gender:</span>
                  <p className="text-sm text-gray-600 capitalize">{detail.gender}</p>
                </div>
              )}
              {/* Ingredients (supplement only) */}
              {type === "supplement" && detail.ingredient && (
                <div className="col-span-2">
                  <span className="text-sm font-medium text-gray-700">Ingredients:</span>
                  <div className="flex flex-wrap gap-1 mt-1">
                    {parseIngredients(detail.ingredient).map((ingredient, idx) => (
                      <span key={idx} className="px-2 py-1 bg-green-100 text-green-800 rounded-md text-xs">
                        {ingredient}
                      </span>
                    ))}
                  </div>
                </div>
              )}
              {/* Type */}
              <div>
                <span className="text-sm font-medium text-gray-700">Type:</span>
                <p className="text-sm text-gray-600 capitalize">{product.type}</p>
              </div>
              {/* Modal ID */}
              <div>
                <span className="text-sm font-medium text-gray-700">
                  {type === "equipment" ? "Equipment ID:" : "Supplement ID:"}
                </span>
                <p className="text-sm text-gray-600">{detail.id}</p>
              </div>
            </div>
            {/* Categories */}
            <div className="flex flex-wrap gap-2">
              {categoryNames.map((categoryName, idx) => (
                <span
                  key={idx}
                  className={`px-3 py-1 ${
                    type === "equipment"
                      ? "bg-blue-100 text-blue-800"
                      : "bg-purple-100 text-purple-800"
                  } rounded-full text-sm font-medium`}
                >
                  {categoryName}
                </span>
              ))}
            </div>
            {/* Rating */}
            <div className="flex items-center space-x-2">
              <Rating rating={product.rating || 0} />
            </div>
            {/* Price Display with Discount */}
            <div className="flex flex-col mb-4 space-y-3 text-center md:text-left">
              {isPromotionActive && discount > 0 ? (
                <>
                  {/* Original Price (crossed out) */}
                  <div className="flex items-center space-x-2">
                    <p className="line-through text-gray-500 text-lg">
                      ${price.toFixed(2)}
                    </p>
                    {/* Discount Badge */}
                    <span className="bg-red-500 text-white px-2 py-1 rounded text-sm">
                      -{(discount * 100).toFixed(0)}% {/* Convert 0.15 → 15% */}
                    </span>
                  </div>
                  {/* Discounted Price */}
                  <p className="text-4xl font-bold text-green-600">
                    ${discountedPrice.toFixed(2)}
                  </p>
                  {/* Promotion Details */}
                  <p className="text-sm font-light text-gray-400">
                    {promotion.promotionName} - Valid until{" "}
                    {new Date(promotion.endDate * 1000).toLocaleDateString()}
                  </p>
                </>
              ) : (
                <p className="text-4xl font-bold text-gray-800">
                  ${price.toFixed(2)}
                </p>
              )}
            </div>
            {/* Quantity Selector */}
            <div className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg">
              <span className="text-sm font-medium text-gray-700">Quantity:</span>
              <div className="flex items-center space-x-3">
                <button
                  onClick={() => handleQuantityChange(-1)}
                  disabled={quantity <= 1}
                  className="w-8 h-8 flex items-center justify-center bg-gray-200 rounded-full hover:bg-gray-300 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  -
                </button>
                <span className="w-12 text-center font-medium text-lg">
                  {quantity}
                </span>
                <button
                  onClick={() => handleQuantityChange(1)}
                  disabled={quantity >= product.stock}
                  className="w-8 h-8 flex items-center justify-center bg-gray-200 rounded-full hover:bg-gray-300 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  +
                </button>
              </div>
              <div className="text-sm text-gray-500">
                Max: {product.stock || 0}
              </div>
            </div>
            {/* Total Price */}
            <div className="flex justify-between items-center p-4 bg-gray-100 rounded-lg">
              <span className="text-lg font-medium text-gray-700">Total:</span>
              <span className="text-2xl font-bold text-gray-800">
                ${(currentPrice * quantity).toFixed(2)}
              </span>
            </div>
            {/* Supplier Info */}
            {supplier && (
              <div className="flex items-center p-3 bg-gray-50 rounded-lg space-x-3">
                {supplier.image && (
                  <ApiImage
                    imageId={supplier.image}
                    alt={supplier.name}
                    className="w-12 h-12 rounded-full object-cover"
                  />
                )}
                <div className="flex-1">
                  <p className="text-sm text-gray-700">
                    <span className="font-medium">Supplier:</span> {supplier.name}
                  </p>
                  <p className="text-sm text-gray-600">
                    Contact: {supplier.contact}
                  </p>
                  <p className="text-xs text-gray-500">
                    Address: {supplier.address}
                  </p>
                </div>
              </div>
            )}
            {/* Button Group */}
            <div className="group">
              <button
                onClick={handleAddToCart}
                className={`w-full transition-all duration-150 text-white border-b-8 rounded-lg group-hover:border-t-8 group-hover:border-b-0 group-hover:shadow-lg ${
                  type === "supplement"
                    ? "bg-purple-700 border-b-purple-700 group-hover:bg-purple-700 group-hover:border-t-purple-700"
                    : "bg-blue-700 border-b-blue-700 group-hover:bg-blue-700 group-hover:border-t-blue-700"
                }`}
                disabled={!product.stock || product.stock === 0}
              >
                <div
                  className={`px-8 py-4 duration-150 rounded-lg ${
                    type === "supplement"
                      ? "bg-purple-500 group-hover:bg-purple-700"
                      : "bg-blue-500 group-hover:bg-blue-700"
                  }`}
                >
                  {product.stock > 0
                    ? `Add ${quantity} to cart`
                    : "Out of Stock"}
                </div>
              </button>
            </div>
            {/* Stock */}
            <div className="flex items-center space-x-3 group">
              <div
                className={`w-3 h-3 rounded-full group-hover:animate-ping ${
                  (product.stock || 0) > 0 ? "bg-green-400" : "bg-red-400"
                }`}
              ></div>
              <div className="text-sm">
                {(product.stock || 0) > 0
                  ? `${product.stock}+ pcs. in stock`
                  : "Out of stock"}
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

export default ProductModal;
