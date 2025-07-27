import React, { useState } from "react";
import useCartStore from "../stores/useCartStore";
import MainLayout from "../layouts/MainLayout";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  PayPalScriptProvider,
  PayPalButtons,
  usePayPalScriptReducer,
} from "@paypal/react-paypal-js";
import ApiImage from "../components/ui/ApiImage";
import { PAYPAL_CLIENT_ID } from "../utils/config";
import {createOrder, createPayment, createOrderDetail} from "../services/orderService"


// PayPal Button Component
function PayPalCheckoutButton({ amount, onSuccess, onError }) {
  const [{ isPending }] = usePayPalScriptReducer();

  return (
    <>
      {isPending ? (
        <div className="text-center py-2">Loading PayPal...</div>
      ) : null}
      <PayPalButtons
        style={{
          layout: "vertical",
          color: "blue",
          shape: "rect",
          label: "pay",
        }}
        createOrder={(data, actions) => {
          return actions.order.create({
            purchase_units: [
              {
                amount: {
                  value: amount.toFixed(2),
                  currency_code: "USD",
                },
              },
            ],
          });
        }}
        onApprove={async (data, actions) => {
          const order = await actions.order.capture();
          onSuccess(order);
        }}
        onError={(err) => {
          console.error("PayPal Error:", err);
          onError(err);
        }}
      />
    </>
  );
}

function CheckoutPage() {
  const {
    cart,
    getTotal,
    getTotalItems,
    incrementQuantity,
    decrementQuantity,
    removeFromCart,
    clearCart,
  } = useCartStore();

  const [paymentStatus, setPaymentStatus] = useState({
    paid: false,
    message: "",
  });

  const total = getTotal();
  const totalItems = getTotalItems();
  const finalTotal = parseFloat((total * 1.1).toFixed(2)); // Including tax

  // Calculate total savings
  const totalSavings = cart.reduce((savings, item) => {
    if (item.discount && item.discount > 0) {
      const originalPrice = item.originalPrice || (item.price / (1 - item.discount));
      return savings + ((originalPrice - item.price) * item.quantity);
    }
    return savings;
  }, 0);

  const handlePaymentSuccess = async (details) => {
    try {
      // Extract the transaction code from PayPal response
      const transactionCode = details.purchase_units[0].payments?.captures[0]?.id;
      console.log("Transaction code:", transactionCode);

      // 1. Create order
      const orderResponse = await createOrder({
        orderDate: new Date().toISOString(),
        totalAmount: finalTotal
      });

      if (!orderResponse.success) {
        throw new Error("Failed to create order: " + JSON.stringify(orderResponse.errors));
      }

      // 2. Get order ID from response
      const orderId = orderResponse.data.id;
      console.log("Order created with ID:", orderId);

      // 3. Create payment with transaction details
      const paymentResponse = await createPayment({
        transactionCode: transactionCode,
        paymentDate: new Date().toISOString(),
        currency: "USD",
        amount: finalTotal,
        status: true,
        paymentMethodId: 1, // PayPal payment method ID
        orderId: orderId
      });

      if (!paymentResponse.success) {
        throw new Error("Failed to record payment: " + JSON.stringify(paymentResponse.errors));
      }

      // 4. Create order details for each cart item
      const orderDetailPromises = cart.map(item => {
        const orderDetail = {
          orderId: orderId,
          productId: item.id,
          quantity: item.quantity,
          unitPrice: item.price,
          subTotal: item.price * item.quantity
        };

        return createOrderDetail(orderDetail);
      });

      // Process all order details in parallel
      const detailResults = await Promise.all(orderDetailPromises);
      const failedDetails = detailResults.filter(result => !result.success);

      if (failedDetails.length > 0) {
        console.warn("Some order details failed to save:", failedDetails);
      }

      // Update UI to show success
      setPaymentStatus({
        paid: true,
        message: `Thank you, ${
          details.payer?.name?.given_name || "customer"
        }! Your payment was successful.\n Your products was delivered to you at least 3 days.`
      });

      clearCart();

    } catch (error) {
      console.error("Error processing order:", error);

      setPaymentStatus({
        paid: false,
        message: "Payment was processed but we encountered an issue saving your order details. Please contact customer support."
      });
    }
  };

  const handlePaymentError = (error) => {
    setPaymentStatus({
      paid: false,
      message:
        "Payment failed. Please try again or use a different payment method. or Login again!!!",
    });
    console.error("Payment Error:", error);
  };

  return (
    <MainLayout>
      <section className="bg-white py-8 antialiased md:py-16">
        <div className="mx-auto max-w-screen-xl px-4 2xl:px-0">
          {paymentStatus.paid ? (
            <div className="bg-green-50 p-6 rounded-lg border border-green-200 text-center">
              <FontAwesomeIcon
                icon={["fas", "check-circle"]}
                size="3x"
                className="text-green-500 mb-4"
              />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">
                Payment Successful!
              </h3>
              <p className="text-gray-700 mb-4">{paymentStatus.message}</p>
              <a
                href="/products"
                className="inline-flex items-center gap-2 text-sm font-medium text-blue-700 underline hover:no-underline"
              >
                Continue Shopping
                <svg
                  className="h-5 w-5"
                  aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke="currentColor"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M19 12H5m14 0-4 4m4-4-4-4"
                  />
                </svg>
              </a>
            </div>
          ) : (
            <>
              <h2 className="text-xl font-semibold text-gray-900 sm:text-2xl">
                Shopping Cart ({totalItems} items)
              </h2>

              <div className="mt-6 sm:mt-8 md:gap-6 lg:flex lg:items-start xl:gap-8">
                <div className="mx-auto w-full flex-none lg:max-w-2xl xl:max-w-4xl">
                  {/* List of products in your cart */}
                  <div className="space-y-6">
                    {cart.length === 0 ? (
                      <div className="flex flex-col items-center justify-center py-16 text-center">
                        <FontAwesomeIcon
                          icon={["fas", "shopping-cart"]}
                          size="3x"
                          className="text-gray-300 mb-4"
                        />
                        <h3 className="text-xl font-semibold text-gray-900 mb-2">
                          Your cart is empty
                        </h3>
                        <p className="text-gray-500">
                          Add some items to get started!
                        </p>
                      </div>
                    ) : (
                      cart.map((item) => (
                        <div
                          key={item.id}
                          className="rounded-lg border border-gray-200 bg-white p-4 shadow-sm md:p-6"
                        >
                          <div className="space-y-4 md:flex md:items-center md:justify-between md:gap-6 md:space-y-0">
                            {/* Product Image */}
                            <a href="#" className="shrink-0 md:order-1">
                              <ApiImage
                                imageId={item.image}
                                alt={item.name}
                                className="h-20 w-20 object-cover rounded-lg"
                              />
                            </a>

                            {/* Quantity Controls and Price */}
                            <div className="flex items-center justify-between md:order-3 md:justify-end">
                              <div className="flex items-center">
                                <button
                                  type="button"
                                  onClick={() => decrementQuantity(item.id)}
                                  className="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-md border border-gray-300 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-100"
                                >
                                  <svg
                                    className="h-2.5 w-2.5 text-gray-900"
                                    aria-hidden="true"
                                    xmlns="http://www.w3.org/2000/svg"
                                    fill="none"
                                    viewBox="0 0 18 2"
                                  >
                                    <path
                                      stroke="currentColor"
                                      strokeLinecap="round"
                                      strokeLinejoin="round"
                                      strokeWidth="2"
                                      d="M1 1h16"
                                    />
                                  </svg>
                                </button>
                                <span className="w-10 shrink-0 text-center text-sm font-medium text-gray-900">
                                  {item.quantity}
                                </span>
                                <button
                                  type="button"
                                  onClick={() => incrementQuantity(item.id)}
                                  disabled={item.quantity >= item.stock}
                                  className="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-md border border-gray-300 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                  <svg
                                    className="h-2.5 w-2.5 text-gray-900"
                                    aria-hidden="true"
                                    xmlns="http://www.w3.org/2000/svg"
                                    fill="none"
                                    viewBox="0 0 18 18"
                                  >
                                    <path
                                      stroke="currentColor"
                                      strokeLinecap="round"
                                      strokeLinejoin="round"
                                      strokeWidth="2"
                                      d="M9 1v16M1 9h16"
                                    />
                                  </svg>
                                </button>
                              </div>
                              <div className="text-end md:order-4 md:w-32">
                                {/* Promotion Badge */}
                                {item.discount && item.discount > 0 && (
                                  <div className="mb-1">
                                    <span className="bg-red-500 text-white px-2 py-1 rounded text-xs font-bold">
                                      -{(item.discount * 100).toFixed(0)}% OFF
                                    </span>
                                  </div>
                                )}
                                <p className="text-base font-bold text-gray-900">
                                  ${(item.price * item.quantity).toFixed(2)}
                                </p>
                                {item.discount && item.discount > 0 && (
                                  <p className="text-sm text-gray-500 line-through">
                                    ${((item.originalPrice || (item.price / (1 - item.discount))) * item.quantity).toFixed(2)}
                                  </p>
                                )}
                              </div>
                            </div>

                            {/* Product Details */}
                            <div className="w-full min-w-0 flex-1 space-y-4 md:order-2 md:max-w-md">
                              <a
                                href="#"
                                className="text-base font-medium text-gray-900 hover:underline"
                              >
                                {item.name}
                              </a>

                              {/* Product Type Badge */}
                              <div className="flex items-center gap-2">
                                <span
                                  className={`px-2 py-1 rounded-full text-xs font-medium ${
                                    item.type === "equipment"
                                      ? "bg-blue-100 text-blue-800"
                                      : "bg-purple-100 text-purple-800"
                                  }`}
                                >
                                  {item.type === "equipment"
                                    ? "Equipment"
                                    : "Supplement"}
                                </span>
                                <span className="text-sm text-gray-500">
                                  Stock: {item.stock}
                                </span>
                              </div>

                              {/* Unit Price with Promotion */}
                              <div className="flex items-center space-x-2">
                                {item.discount && item.discount > 0 ? (
                                  <>
                                    <p className="text-sm text-gray-500 line-through">
                                      ${(item.originalPrice || (item.price / (1 - item.discount))).toFixed(2)} each
                                    </p>
                                    <p className="text-sm font-medium text-green-600">
                                      ${item.price.toFixed(2)} each
                                    </p>
                                  </>
                                ) : (
                                  <p className="text-sm text-gray-500">
                                    ${item.price.toFixed(2)} each
                                  </p>
                                )}
                              </div>

                              <div className="flex items-center gap-4">
                                <button
                                  type="button"
                                  className="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 hover:underline"
                                >
                                  <svg
                                    className="me-1.5 h-5 w-5"
                                    aria-hidden="true"
                                    xmlns="http://www.w3.org/2000/svg"
                                    width="24"
                                    height="24"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                  >
                                    <path
                                      stroke="currentColor"
                                      strokeLinecap="round"
                                      strokeLinejoin="round"
                                      strokeWidth="2"
                                      d="M12.01 6.001C6.5 1 1 8 5.782 13.001L12.011 20l6.23-7C23 8 17.5 1 12.01 6.002Z"
                                    />
                                  </svg>
                                  Add to Favorites
                                </button>

                                <button
                                  type="button"
                                  onClick={() => removeFromCart(item.id)}
                                  className="inline-flex items-center text-sm font-medium text-red-600 hover:underline"
                                >
                                  <svg
                                    className="me-1.5 h-5 w-5"
                                    aria-hidden="true"
                                    xmlns="http://www.w3.org/2000/svg"
                                    width="24"
                                    height="24"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                  >
                                    <path
                                      stroke="currentColor"
                                      strokeLinecap="round"
                                      strokeLinejoin="round"
                                      strokeWidth="2"
                                      d="M6 18 17.94 6M18 18 6.06 6"
                                    />
                                  </svg>
                                  Remove
                                </button>
                              </div>
                            </div>
                          </div>
                        </div>
                      ))
                    )}
                  </div>

                  {/* Clear Cart Button */}
                  {cart.length > 0 && (
                    <div className="mt-6 flex justify-end">
                      <button
                        onClick={clearCart}
                        className="inline-flex items-center text-sm font-medium text-red-600 hover:underline"
                      >
                        <FontAwesomeIcon
                          icon={["fas", "trash"]}
                          className="me-1.5"
                        />
                        Clear Cart
                      </button>
                    </div>
                  )}
                </div>

                {/* Order Summary with PayPal */}
                {cart.length > 0 && (
                  <div className="mx-auto mt-6 max-w-4xl flex-1 space-y-6 lg:mt-0 lg:w-full">
                    <div className="space-y-4 rounded-lg border border-gray-200 bg-white p-4 shadow-sm sm:p-6">
                      <p className="text-xl font-semibold text-gray-900">
                        Order Summary
                      </p>

                      <div className="space-y-4">
                        <div className="space-y-2">
                          <dl className="flex items-center justify-between gap-4">
                            <dt className="text-base font-normal text-gray-500">
                              Subtotal ({totalItems} items)
                            </dt>
                            <dd className="text-base font-medium text-gray-900">
                              ${total.toFixed(2)}
                            </dd>
                          </dl>

                          {/* Promotion Savings */}
                          {totalSavings > 0 && (
                            <dl className="flex items-center justify-between gap-4">
                              <dt className="text-base font-normal text-green-600">
                                <FontAwesomeIcon icon={['fas', 'tag']} className="mr-2" />
                                Promotion Savings
                              </dt>
                              <dd className="text-base font-medium text-green-600">
                                -${totalSavings.toFixed(2)}
                              </dd>
                            </dl>
                          )}

                          <dl className="flex items-center justify-between gap-4">
                            <dt className="text-base font-normal text-gray-500">
                              Shipping
                            </dt>
                            <dd className="text-base font-medium text-green-600">
                              Free
                            </dd>
                          </dl>

                          <dl className="flex items-center justify-between gap-4">
                            <dt className="text-base font-normal text-gray-500">
                              Tax
                            </dt>
                            <dd className="text-base font-medium text-gray-900">
                              ${(total * 0.1).toFixed(2)}
                            </dd>
                          </dl>
                        </div>

                        <dl className="flex items-center justify-between gap-4 border-t border-gray-200 pt-2">
                          <dt className="text-base font-bold text-gray-900">
                            Total
                          </dt>
                          <dd className="text-base font-bold text-gray-900">
                            ${finalTotal.toFixed(2)}
                          </dd>
                        </dl>

                        {/* Total Savings Summary */}
                        {totalSavings > 0 && (
                          <div className="bg-green-50 p-3 rounded-lg border border-green-200">
                            <p className="text-sm text-green-800 font-medium">
                              🎉 You saved ${totalSavings.toFixed(2)} with current promotions!
                            </p>
                          </div>
                        )}
                      </div>

                      {/* Payment section - PayPal only */}
                      <div className="pt-4 pb-2">
                        <p className="font-medium text-gray-700 mb-3">
                          Payment Method:{" "}
                          <span className="text-blue-600">PayPal</span>
                        </p>
                      </div>

                      {/* Payment error message */}
                      {paymentStatus.message && !paymentStatus.paid && (
                        <div className="p-4 bg-red-50 text-red-700 rounded-lg">
                          {paymentStatus.message}
                        </div>
                      )}

                      {/* PayPal Buttons */}
                      <div className="mt-4">
                        <PayPalScriptProvider
                          options={{
                            "client-id": PAYPAL_CLIENT_ID, // Replace with your actual client ID from PayPal
                            currency: "USD",
                          }}
                        >
                          <PayPalCheckoutButton
                            amount={finalTotal}
                            onSuccess={handlePaymentSuccess}
                            onError={handlePaymentError}
                          />
                        </PayPalScriptProvider>
                      </div>

                      <div className="flex items-center justify-center mt-4">
                        <a
                          href="/products"
                          className="inline-flex items-center gap-2 text-sm font-medium text-blue-700 underline hover:no-underline"
                        >
                          Continue Shopping
                          <svg
                            className="h-5 w-5"
                            aria-hidden="true"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke="currentColor"
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M19 12H5m14 0-4 4m4-4-4-4"
                            />
                          </svg>
                        </a>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </>
          )}
        </div>
      </section>
    </MainLayout>
  );
}

export default CheckoutPage;
