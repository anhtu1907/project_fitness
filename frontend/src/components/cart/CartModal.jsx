import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import useCartStore from '../../stores/useCartStore';
import { useNavigate } from 'react-router-dom';
import ApiImage from '../ui/ApiImage';

function CartModal({onClose}) {
  const {
    cart,
    getTotal,
    getTotalItems,
    incrementQuantity,
    decrementQuantity,
    removeFromCart,
    clearCart
  } = useCartStore();
  const navigate = useNavigate();

  const total = getTotal();
  const totalItems = getTotalItems();

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-gray-200">
          <h2 className="text-2xl font-bold text-gray-800">
            Shopping Cart ({totalItems} items)
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors"
          >
            <FontAwesomeIcon icon={['fas', 'times']} size="xl" />
          </button>
        </div>

        {/* Cart Items */}
        <div className="flex-1 overflow-y-auto max-h-96">
          {cart.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16">
              <FontAwesomeIcon
                icon={['fas', 'shopping-cart']}
                size="3x"
                className="text-gray-300 mb-4"
              />
              <p className="text-gray-500 text-lg">Your cart is empty</p>
              <p className="text-gray-400 text-sm">Add some items to get started!</p>
            </div>
          ) : (
            <div className="p-6 space-y-4">
              {cart.map((item, index) => (
                <div key={item.id || index} className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg">
                  {/* Product Image */}
                  <div className="flex-shrink-0">
                    <ApiImage
                      imageId={item.image}
                      alt={item.name}
                      className="w-20 h-20 object-cover rounded-lg"
                    />
                  </div>

                  {/* Product Info */}
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-800 mb-1">{item.name}</h3>
                    <p className="text-sm text-gray-500 mb-2">
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                        item.type === 'equipment'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-purple-100 text-purple-800'
                      }`}>
                        {item.type === 'equipment' ? 'Equipment' : 'Supplement'}
                      </span>
                    </p>

                    {/* Price with Promotion Display */}
                    <div className="flex items-center space-x-2">
                      {item.discount && item.discount > 0 ? (
                        <>
                          <p className="text-sm text-gray-500 line-through">
                            ${item.originalPrice?.toFixed(2) || item.price.toFixed(2)}
                          </p>
                          <span className="bg-red-500 text-white px-2 py-1 rounded text-xs font-bold">
                            -{(item.discount * 100).toFixed(0)}%
                          </span>
                          <p className="text-lg font-bold text-green-600">${item.price.toFixed(2)}</p>
                        </>
                      ) : (
                        <p className="text-lg font-bold text-gray-800">${item.price.toFixed(2)}</p>
                      )}
                    </div>

                    <p className="text-xs text-gray-500">Stock: {item.stock}</p>
                  </div>

                  {/* Quantity Controls */}
                  <div className="flex items-center space-x-2">
                    <button
                      onClick={() => decrementQuantity(item.id)}
                      className="w-8 h-8 flex items-center justify-center bg-gray-200 rounded-full hover:bg-gray-300 transition-colors"
                    >
                      <FontAwesomeIcon icon={['fas', 'minus']} size="sm" />
                    </button>
                    <span className="w-8 text-center font-semibold">{item.quantity}</span>
                    <button
                      onClick={() => incrementQuantity(item.id)}
                      disabled={item.quantity >= item.stock}
                      className="w-8 h-8 flex items-center justify-center bg-gray-200 rounded-full hover:bg-gray-300 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <FontAwesomeIcon icon={['fas', 'plus']} size="sm" />
                    </button>
                  </div>

                  {/* Subtotal */}
                  <div className="text-right">
                    <p className="font-bold text-gray-800">${(item.price * item.quantity).toFixed(2)}</p>
                    {item.discount && item.discount > 0 && (
                      <p className="text-xs text-green-600">
                        You save: ${((item.originalPrice || item.price) * item.discount * item.quantity).toFixed(2)}
                      </p>
                    )}
                  </div>

                  {/* Remove Button */}
                  <button
                    onClick={() => removeFromCart(item.id)}
                    className="text-red-500 hover:text-red-700 transition-colors"
                  >
                    <FontAwesomeIcon icon={['fas', 'trash']} />
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Footer */}
        {cart.length > 0 && (
          <div className="border-t border-gray-200 p-6 bg-gray-50">
            {/* Savings Summary */}
            {cart.some(item => item.discount && item.discount > 0) && (
              <div className="mb-4 p-3 bg-green-50 rounded-lg border border-green-200">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-green-800">
                    <FontAwesomeIcon icon={['fas', 'tag']} className="mr-2" />
                    Total Savings:
                  </span>
                  <span className="text-lg font-bold text-green-600">
                    ${cart.reduce((savings, item) => {
                      if (item.discount && item.discount > 0) {
                        const originalPrice = item.originalPrice || (item.price / (1 - item.discount));
                        return savings + ((originalPrice - item.price) * item.quantity);
                      }
                      return savings;
                    }, 0).toFixed(2)}
                  </span>
                </div>
              </div>
            )}

            {/* Total */}
            <div className="flex justify-between items-center mb-4">
              <span className="text-xl font-bold text-gray-800">Total:</span>
              <span className="text-2xl font-bold text-gray-800">${total.toFixed(2)}</span>
            </div>

            {/* Action Buttons */}
            <div className="flex space-x-4">
              <button
                onClick={clearCart}
                className="flex-1 py-3 px-4 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-medium"
              >
                Clear Cart
              </button>
              <button
                onClick={() => {
                  navigate("/user/checkout");
                  onClose();
                }}
                className="flex-1 py-3 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-medium"
              >
                Checkout
              </button>
            </div>

            {/* Continue Shopping */}
            <button
              onClick={onClose}
              className="w-full mt-3 py-2 text-blue-600 hover:text-blue-800 transition-colors font-medium"
            >
              Continue Shopping
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

export default CartModal;