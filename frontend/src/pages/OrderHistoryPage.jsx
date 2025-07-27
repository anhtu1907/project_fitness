import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import MainLayout from "../layouts/MainLayout";
import { getOrdersByUserId } from "../services/orderService";
import useUserStore from "../stores/useUserStore";

function OrderHistoryPage() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { user } = useUserStore();

  useEffect(() => {
    const fetchOrders = async () => {
      try {
        setLoading(true);
        if (user?.id) {
          const response = await getOrdersByUserId(user.id);
          if (response.success) {
            setOrders(response.data || []);
          } else {
            setError("Failed to load orders");
          }
        }
      } catch (err) {
        console.error("Error fetching orders:", err);
        setError("Error loading orders");
      } finally {
        setLoading(false);
      }
    };

    fetchOrders();
  }, [user?.id]);

  const formatDate = (timestamp) => {
    return new Date(timestamp * 1000).toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const getStatusBadge = (order) => {
    if (order.delivered) {
      return (
        <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
          <FontAwesomeIcon icon={['fas', 'check-circle']} className="mr-1" />
          Delivered
        </span>
      );
    } else if (order.status) {
      return (
        <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
          <FontAwesomeIcon icon={['fas', 'truck']} className="mr-1" />
          In Transit
        </span>
      );
    } else {
      return (
        <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
          <FontAwesomeIcon icon={['fas', 'clock']} className="mr-1" />
          Processing
        </span>
      );
    }
  };

  // Loading state
  if (loading) {
    return (
      <MainLayout>
        <div className="container mx-auto px-4 py-8">
          <div className="flex justify-center items-center min-h-[400px]">
            <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-600"></div>
          </div>
        </div>
      </MainLayout>
    );
  }

  // Error state
  if (error) {
    return (
      <MainLayout>
        <div className="container mx-auto px-4 py-8">
          <div className="text-center py-16">
            <div className="text-red-400 text-6xl mb-4">⚠️</div>
            <h3 className="text-xl font-semibold text-red-700 mb-2">
              Error Loading Orders
            </h3>
            <p className="text-red-600">{error}</p>
            <button
              onClick={() => window.location.reload()}
              className="mt-4 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Try Again
            </button>
          </div>
        </div>
      </MainLayout>
    );
  }

  return (
    <MainLayout>
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          {/* Header */}
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-900">Order History</h1>
            <p className="mt-2 text-gray-600">
              Track your orders and view purchase history
            </p>
          </div>

          {/* Orders Summary */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div className="bg-white rounded-lg shadow p-6">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <FontAwesomeIcon
                    icon={['fas', 'shopping-bag']}
                    className="h-8 w-8 text-blue-600"
                  />
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Total Orders</p>
                  <p className="text-2xl font-semibold text-gray-900">
                    {orders.length}
                  </p>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-lg shadow p-6">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <FontAwesomeIcon
                    icon={['fas', 'dollar-sign']}
                    className="h-8 w-8 text-green-600"
                  />
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Total Spent</p>
                  <p className="text-2xl font-semibold text-gray-900">
                    ${orders.reduce((sum, order) => sum + order.totalAmount, 0).toFixed(2)}
                  </p>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-lg shadow p-6">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <FontAwesomeIcon
                    icon={['fas', 'check-circle']}
                    className="h-8 w-8 text-green-600"
                  />
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Delivered</p>
                  <p className="text-2xl font-semibold text-gray-900">
                    {orders.filter(order => order.delivered).length}
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* Orders List */}
          {orders.length === 0 ? (
            <div className="text-center py-16">
              <div className="text-gray-400 text-6xl mb-4">📦</div>
              <h3 className="text-xl font-semibold text-gray-700 mb-2">
                No Orders Found
              </h3>
              <p className="text-gray-600 mb-6">
                You haven't placed any orders yet. Start shopping to see your order history!
              </p>
              <button
                onClick={() => window.location.href = '/products'}
                className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
              >
                Start Shopping
              </button>
            </div>
          ) : (
            <div className="bg-white shadow overflow-hidden sm:rounded-md">
              <div className="flex flex-col divide-y divide-gray-200">
                {orders.map((order) => (
                  <div key={order.id} className="px-6 py-4 hover:bg-gray-50 transition-colors">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center">
                        <div className="flex-shrink-0">
                          <div className="h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                            <FontAwesomeIcon
                              icon={['fas', 'receipt']}
                              className="h-5 w-5 text-blue-600"
                            />
                          </div>
                        </div>
                        <div className="ml-4">
                          <div className="flex items-center space-x-2">
                            <p className="text-sm font-medium text-gray-900">
                              Order #{order.id}
                            </p>
                            {getStatusBadge(order)}
                          </div>
                          <p className="text-sm text-gray-500">
                            {formatDate(order.orderDate)}
                          </p>
                        </div>
                      </div>
                      <div className="flex items-center space-x-4">
                        <div className="text-right">
                          <p className="text-sm font-medium text-gray-900">
                            ${order.totalAmount.toFixed(2)}
                          </p>
                          <p className="text-sm text-gray-500">Total</p>
                        </div>
                        <button className="text-blue-600 hover:text-blue-800 transition-colors">
                          <FontAwesomeIcon icon={['fas', 'chevron-right']} />
                        </button>
                      </div>
                    </div>

                    {/* Order Details Preview */}
                    <div className="mt-4 flex flex-col sm:flex-row sm:gap-8 gap-2 text-sm">
                      <div className="flex flex-col">
                        <span className="text-gray-500">Order Date:</span>
                        <p className="font-medium">
                          {new Date(order.orderDate * 1000).toLocaleDateString()}
                        </p>
                      </div>
                      <div className="flex flex-col">
                        <span className="text-gray-500">Status:</span>
                        <p className="font-medium">
                          {order.delivered ? 'Delivered' :
                           order.status ? 'In Transit' : 'Processing'}
                        </p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}


          {/* {orders.length > 0 && (
            <div className="mt-8 flex justify-center">
              <p className="text-sm text-gray-600">
                Showing {orders.length} orders
              </p>
            </div>
          )} */}
        </div>
      </div>
    </MainLayout>
  );
}

export default OrderHistoryPage;