import React, { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { PageBreadcrumb } from '../../components'
import { fetchUserById, UserResponse } from './data'
import { APICore } from '../../helpers/api/apiCore'

const api = new APICore();

type OrderResponse = {
  id: number;
  orderDate: string;
  totalAmount: number;
  status: boolean;
  delivered: boolean;
  user: string;
  payment?: number;
};

const UserOverview = ({ userId }: { userId: string }) => {
  const [orders, setOrders] = useState<OrderResponse[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (userId) {
      api.get(`/api/order/user/${userId}`)
        .then(res => setOrders(res.data.data || []))
        .finally(() => setLoading(false));
    }
  }, [userId]);

  // Tổng số đơn hàng
  const totalOrders = orders.length;
  // Tổng số tiền đã chi
  const totalSpent = orders.reduce((sum, o) => sum + (o.totalAmount || 0), 0);
  // Số đơn đã hoàn thành
  const completedOrders = orders.filter(o => o.status).length;
  // Số đơn đã giao
  const deliveredOrders = orders.filter(o => o.delivered).length;

  return (
    <div className="lg:col-span-3">
      <div className="card">
        <div className="card-header">
          <h6 className="card-title">User Overview</h6>
        </div>
        <div className="p-6">
          {loading ? (
            <div className="text-center py-6">Loading order statistics...</div>
          ) : (
            <div className="grid lg:grid-cols-4 gap-6">
              <div className="flex items-center gap-5">
                <i className="mgc_shopping_cart_2_line text-orange-500 text-5xl h-10 w-10"></i>
                <div>
                  <h4 className="text-lg text-gray-700 dark:text-gray-300 font-medium">{totalOrders}</h4>
                  <span className="text-sm">Total Orders</span>
                </div>
              </div>
              <div className="flex items-center gap-5">
                <i className="mgc_check_circle_line text-green-600 text-5xl h-10 w-10"></i>
                <div>
                  <h4 className="text-lg text-gray-700 dark:text-gray-300 font-medium">{completedOrders}</h4>
                  <span className="text-sm">Completed Orders</span>
                </div>
              </div>
              <div className="flex items-center gap-5">
                <i className="mgc_truck_line text-blue-500 text-5xl h-10 w-10"></i>
                <div>
                  <h4 className="text-lg text-gray-700 dark:text-gray-300 font-medium">{deliveredOrders}</h4>
                  <span className="text-sm">Delivered Orders</span>
                </div>
              </div>
              <div className="flex items-center gap-5">
                <i className="mgc_wallet_2_line text-yellow-500 text-5xl h-10 w-10"></i>
                <div>
                  <h4 className="text-lg text-gray-700 dark:text-gray-300 font-medium">{totalSpent.toLocaleString()} $</h4>
                  <span className="text-sm">Total Spent</span>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}


const AboutUser = ({ user }: { user: UserResponse }) => {
  return (
    <div className="lg:col-span-3">
      <div className="card">
        <div className="card-header">
          <h4 className="card-title">About User</h4>
        </div>
        <div className="p-6 space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-sm text-gray-500">Full Name</p>
              <h5 className="font-medium text-gray-700">{user.firstName} {user.lastName}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Username</p>
              <h5 className="font-medium text-gray-700">{user.username}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Email</p>
              <h5 className="font-medium text-gray-700">{user.email}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Phone</p>
              <h5 className="font-medium text-gray-700">{user.phone || 'N/A'}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Address</p>
              <h5 className="font-medium text-gray-700">{user.address || 'N/A'}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Date of Birth</p>
              <h5 className="font-medium text-gray-700">{user.dob ? new Date(user.dob.toString()).toLocaleDateString() : 'N/A'}</h5>
            </div>
          </div>

          <div className="mt-6">
            <h6 className="text-sm text-gray-800 font-medium mb-2">Role</h6>
            <p className="font-semibold text-primary">{user.role.role}</p>
            <p className="text-sm text-gray-500">{user.role.description}</p>

            {user.role.permissions && (
              <div className="mt-4">
                <h6 className="text-sm text-gray-800 font-medium mb-2">Permissions</h6>
                <ul className="list-disc ps-5 text-sm text-gray-600">
                  {user.role.permissions.map((perm, idx) => (
                    <li key={idx}>
                      <strong>{perm.permission}</strong>: {perm.description || 'No description'}
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

const PAGE_SIZE = 5;

const UserOrderTable = ({ orders }: { orders: OrderResponse[] }) => {
  const [page, setPage] = useState(1);

  const totalPages = Math.ceil(orders.length / PAGE_SIZE);
  const paginatedOrders = orders.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  return (
    <div className="card mt-6">
      <div className="card-header">
        <h6 className="card-title">Order List</h6>
      </div>
      <div className="p-6">
        <table className="min-w-full border">
          <thead>
            <tr className="bg-gray-100">
              <th className="p-2 border">Order ID</th>
              <th className="p-2 border">Order Date</th>
              <th className="p-2 border">Total Amount</th>
              <th className="p-2 border">Status</th>
              <th className="p-2 border">Delivered</th>
              <th className="p-2 border">Payment ID</th>
            </tr>
          </thead>
          <tbody>
            {paginatedOrders.length > 0 ? (
              paginatedOrders.map((order) => (
                <tr key={order.id}>
                  <td className="p-2 border">{order.id}</td>
                  <td className="p-2 border">{order.orderDate ? new Date(order.orderDate).toLocaleString() : "N/A"}</td>
                  <td className="p-2 border">{order.totalAmount?.toLocaleString()} VND</td>
                  <td className="p-2 border">
                    {order.status ? (
                      <span className="px-2 py-1 rounded bg-green-500 text-white text-xs font-semibold">Completed</span>
                    ) : (
                      <span className="px-2 py-1 rounded bg-yellow-400 text-white text-xs font-semibold">Pending</span>
                    )}
                  </td>
                  <td className="p-2 border">
                    {order.delivered ? (
                      <span className="px-2 py-1 rounded bg-green-500 text-white text-xs font-semibold">Delivered</span>
                    ) : (
                      <span className="px-2 py-1 rounded bg-red-500 text-white text-xs font-semibold">Not Delivered</span>
                    )}
                  </td>
                  <td className="p-2 border">{order.payment ?? "N/A"}</td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={6} className="p-2 border text-center text-gray-400">No orders found</td>
              </tr>
            )}
          </tbody>
        </table>
        {/* Pagination controls */}
        {totalPages > 1 && (
          <div className="flex justify-center items-center mt-4 gap-2">
            <button
              className="btn px-3 py-1 bg-gray-200"
              disabled={page === 1}
              onClick={() => setPage(page - 1)}
            >
              Prev
            </button>
            <span className="mx-2 text-sm">
              Page {page} / {totalPages}
            </span>
            <button
              className="btn px-3 py-1 bg-gray-200"
              disabled={page === totalPages}
              onClick={() => setPage(page + 1)}
            >
              Next
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

const UserDetail = () => {
  const { id } = useParams<{ id: string }>();
  const [user, setUser] = useState<UserResponse | null>(null);
  const [orders, setOrders] = useState<OrderResponse[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (id) {
      fetchUserById(id)
        .then(data => setUser(data))
        .finally(() => setLoading(false));
      // Lấy danh sách đơn hàng của user
      api.get(`/api/order/user/${id}`)
        .then(res => setOrders(res.data.data || []));
    }
  }, [id]);

  if (loading) return <div className="text-center py-10">Loading...</div>;
  if (!user) return <div className="text-center py-10 text-red-500">User not found</div>;

  return (
    <>
      <PageBreadcrumb name="User Detail" title="User Detail" breadCrumbItems={["Fitmate", "Users", "User Detail"]} />
      <div className="grid lg:grid-cols-3 gap-6">
        <UserOverview userId={user.id} />
        <AboutUser user={user} />
      </div>
      <UserOrderTable orders={orders} />
    </>
  )
}

export default UserDetail
