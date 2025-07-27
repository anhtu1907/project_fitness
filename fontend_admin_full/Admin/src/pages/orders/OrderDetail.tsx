import React, { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";
import { toast } from "react-hot-toast";

const BASE_URL = config.API_URL;

type OrderResponse = {
  id: number;
  orderDate: string | number;
  totalAmount: number;
  status: boolean;
  delivered: boolean;
  user: string; // userId
  payment?: number;
};

type UserResponse = {
  id: string;
  username: string;
  address?: string;
  deliveryAddress?: string;
  email?: string;
  phone?: string;
};


type Supplier = {
  id: number;
  name: string;
};

type Product = {
  id: number;
  name: string;
  image?: string;
  supplier?: Supplier;
};

type OrderDetailResponse = {
  id: number;
  quantity: number;
  unitPrice: number;
  subTotal: number;
  productId: number; 
  product?: Product; 
};

const api = new APICore();

function toInputDate(v?: number | string) {
  if (!v) return "";
  const seconds = typeof v === "string" ? parseInt(v, 10) : v;
  const d = new Date(seconds * 1000);
  return isNaN(d.getTime()) ? "" : d.toISOString().slice(0, 10);
}

const OrderDetailOverview = ({
  order,
  user,
  onUpdateStatus,
  updating,
}: {
  order: OrderResponse;
  user: UserResponse | null;
  onUpdateStatus: (fields: Partial<OrderResponse>) => void;
  updating: boolean;
}) => {
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [pendingUpdate, setPendingUpdate] = useState<Partial<OrderResponse> | null>(null);

  const requestUpdate = (updateFields: Partial<OrderResponse>) => {
    setPendingUpdate(updateFields);
    setConfirmOpen(true);
  };

  const confirmUpdate = () => {
    if (pendingUpdate) {
      onUpdateStatus(pendingUpdate);
    }
    setConfirmOpen(false);
    setPendingUpdate(null);
  };

  const cancelUpdate = () => {
    setConfirmOpen(false);
    setPendingUpdate(null);
  };

  return (
    <div className="lg:col-span-3">
      <div className="card">
        <div className="card-header">
          <h6 className="card-title">Order Overview</h6>
        </div>
        <div className="p-6">
          <div className="grid lg:grid-cols-2 gap-6">
            {/* ...Thông tin khách hàng, đơn hàng như cũ... */}
            <div>
              <p className="text-sm text-gray-500">Customer</p>
              <h5 className="font-medium text-gray-700">{user?.username || order.user}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Delivery Address</p>
              <h5 className="font-medium text-gray-700">{user?.deliveryAddress || user?.address || "N/A"}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Order Date</p>
              <h5 className="font-medium text-gray-700">{toInputDate(order.orderDate)}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Total Amount</p>
              <h5 className="font-medium text-xl text-gray-700">{order.totalAmount?.toLocaleString()} $</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Payment ID</p>
              <h5 className="font-medium text-gray-700">{order.payment ?? "N/A"}</h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Status</p>
              <h5 className="font-medium text-gray-700">
                {order.status ? (
                  <span className="px-3 py-1 rounded bg-green-500 text-white text-xs font-semibold">Completed</span>
                ) : (
                  <span className="px-3 py-1 rounded bg-yellow-400 text-white text-xs font-semibold">Pending</span>
                )}
              </h5>
            </div>
            <div>
              <p className="text-sm text-gray-500">Delivery Status</p>
              <h5 className="font-medium text-gray-700">
                {order.delivered ? (
                  <span className="px-3 py-1 rounded bg-green-500 text-white text-xs font-semibold">Delivered</span>
                ) : (
                  <span className="px-3 py-1 rounded bg-red-500 text-white text-xs font-semibold">Not Delivered</span>
                )}
              </h5>
            </div>
          </div>

          {/* Buttons */}
          <div className="mt-6 flex gap-2">
            {/* <button
              className="btn bg-blue-500 text-white"
              disabled={updating || order.status}
              onClick={() => requestUpdate({ status: true })}
            >
              {updating ? "Updating..." : "Mark as Completed"}
            </button> */}
            <button
              className={`btn ${order.delivered ? "bg-red-500" : "bg-green-500"} text-white`}
              disabled={updating}
              onClick={() => requestUpdate({ delivered: !order.delivered })}
            >
              {updating
                ? "Updating..."
                : order.delivered
                ? "Mark as Not Delivered"
                : "Mark as Delivered"}
            </button>
          </div>
        </div>
      </div>

      {/* Popup Confirm */}
      {confirmOpen && (
        <div className="fixed inset-0 z-50 bg-black bg-opacity-40 flex justify-center items-center">
          <div className="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full">
            <h3 className="text-lg font-semibold mb-4">Confirm Update</h3>
            <p className="text-gray-700 mb-6">
              Are you sure you want to update this order's status?
            </p>
            <div className="flex justify-end gap-3">
              <button
                className="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400"
                onClick={cancelUpdate}
              >
                Cancel
              </button>
              <button
                className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700"
                onClick={confirmUpdate}
              >
                Confirm
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

const OrderDetailTable = ({ details }: { details: OrderDetailResponse[] }) => (
  <div className="card mt-6">
    <div className="card-header">
      <h6 className="card-title">Order Items</h6>
    </div>
    <div className="p-6">
      <table className="min-w-full border">
        <thead>
          <tr className="bg-gray-100">
            <th className="p-2 border">Image</th>
            <th className="p-2 border">Product Name</th>
            <th className="p-2 border">Supplier</th>
            <th className="p-2 border">Quantity</th>
            <th className="p-2 border">Unit Price</th>
            <th className="p-2 border">Subtotal</th>
          </tr>
        </thead>
        <tbody>
          {Array.isArray(details) && details.length > 0 ? (
            details.map((item) => (
              <tr key={item.id}>
                <td className="px-4 py-2 border text-center">
                  {item.product?.image? (
                    <img
                      src={`${BASE_URL}/resources/${item.product.image}`}
                      alt={item.product.name}
                      style={{
                        width: 60,
                        height: 60,
                        objectFit: "cover",
                        borderRadius: 8,
                      }}
                    />
                  ) : (
                    <span className="text-gray-400">No Image</span>
                  )}
                </td>
                <td className="p-2 border">{item.product?.name}</td>
                <td className="p-2 border">
                  {item.product?.supplier?.name || "N/A"}
                </td>
                <td className="p-2 border">{item.quantity}</td>
                <td className="p-2 border">
                  {item.unitPrice?.toLocaleString()} $
                </td>
                <td className="p-2 border">
                  {item.subTotal?.toLocaleString()} $
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={6} className="p-2 border text-center text-gray-400">
                No items
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  </div>
);

const OrderDetail = () => {
  const { id } = useParams<{ id: string }>();
  const [order, setOrder] = useState<OrderResponse | null>(null);
  const [user, setUser] = useState<UserResponse | null>(null);
  const [details, setDetails] = useState<OrderDetailResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [updating, setUpdating] = useState(false);

  useEffect(() => {
  if (!id) return;

  api.get(`/api/order/${id}`).then((orderRes: any) => {
    const orderData = orderRes.data.data;
    setOrder(orderData);

    if (orderData?.user) {
      api.get(`/identity/user/id/${orderData.user}`).then((userRes: any) => {
        setUser(userRes.data.data);
      });
    }

    api.get(`/api/order-detail/order/${id}`).then(async (detailsRes: any) => {
      const detailsData: OrderDetailResponse[] = Array.isArray(detailsRes.data.data)
        ? detailsRes.data.data
        : [detailsRes.data.data].filter(Boolean);

      // Fetch product info separately
      const enrichedDetails = await Promise.all(
        detailsData.map(async (detail) => {
          if (!detail.productId) return detail;
          try {
            const productRes = await api.get(`/api/product/id/${detail.productId}`);
            return {
              ...detail,
              product: productRes.data.data,
            };
          } catch (error) {
            console.warn("Failed to fetch product", detail.productId);
            return detail;
          }
        })
      );

      setDetails(enrichedDetails);
    });
  }).finally(() => setLoading(false));
}, [id]);

  const handleUpdateStatus = async (fields: Partial<OrderResponse>) => {
    if (!order || !id) {
      toast.error("Order ID is invalid!");
      return;
    }

    setUpdating(true);
    try {
      let orderDateEpoch: number;
      if (
        typeof order.orderDate === "string" &&
        !isNaN(Date.parse(order.orderDate))
      ) {
        orderDateEpoch = Math.floor(new Date(order.orderDate).getTime() / 1000);
      } else {
        orderDateEpoch =
          typeof order.orderDate === "number"
            ? order.orderDate
            : Date.now() / 1000;
      }

      const payload: any = {
        orderDate: new Date(orderDateEpoch * 1000).toISOString(),
        totalAmount: order.totalAmount,
        status: fields.status !== undefined ? fields.status : order.status,
        delivered:
          fields.delivered !== undefined ? fields.delivered : order.delivered,
      };

      if (order.payment !== undefined && order.payment !== null) {
        payload.paymentId = order.payment;
      }

      const res = await api.update(`/api/order/${id}`, payload);

      if (res.data?.success) {
        setOrder((prev) => (prev ? { ...prev, ...fields } : prev));
        toast.success("Order updated successfully!");
      } else {
        toast.error(res.data?.message || "Failed to update order");
      }
    } catch (err) {
      toast.error("Failed to update order");
    } finally {
      setUpdating(false);
    }
  };

  if (loading) return <div className="text-center py-10">Loading...</div>;
  if (!order)
    return (
      <div className="text-center py-10 text-red-500">Order not found</div>
    );

  return (
    <>
      <PageBreadcrumb
        name="Order Detail"
        title="Order Detail"
        breadCrumbItems={["Fitmate", "Orders", "Order Detail"]}
      />
      <div className="grid lg:grid-cols-3 gap-6">
        <OrderDetailOverview
          order={order}
          user={user}
          onUpdateStatus={handleUpdateStatus}
          updating={updating}
        />
      </div>
      <OrderDetailTable details={details} />
      <div className="mt-6">
        <Link
          to="/admin/order/orders"
          className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
        >
          <i className="mgc_arrow_left_line me-2"></i> Back to Orders
        </Link>
      </div>
    </>
  );
};

export default OrderDetail;
