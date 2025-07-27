import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";

const api = new APICore();

type Promotion = {
  id: number;
  name: string;
  description: string;
  discount: number;
  startDate: number;
  endDate: number;
  products: {
    productId: number;
    productName: string;
    price: number;
    discountOverride: number;
    startDate: number;
    endDate: number;
  }[];
};

type PromotionOrderStats = {
  orderCount: number;
  orderDetailCount: number;
  paidOrderCount: number;
  unpaidOrderCount: number;
};

const PAGE_SIZE = 5;

function formatDate(epoch: number) {
  if (!epoch) return "";
  const d = new Date(epoch * 1000);
  return d.toLocaleDateString();
}

const Promotions = () => {
  const [promotions, setPromotions] = useState<Promotion[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [deletingId, setDeletingId] = useState<number | null>(null);

  // Popup state
  const [showPopup, setShowPopup] = useState(false);
  const [popupPromotion, setPopupPromotion] = useState<Promotion | null>(null);
  const [orderStats, setOrderStats] = useState<PromotionOrderStats | null>(
    null
  );

  useEffect(() => {
    fetchPromotions();
  }, []);

  const fetchPromotions = async () => {
    try {
      const res = await api.get("/api/promotion");
      setPromotions(res.data.data || []);
    } finally {
      setLoading(false);
    }
  };

  // Hàm lấy thống kê đơn hàng liên quan đến promotion
  const fetchOrderStats = async (promotionId: number) => {
    try {
      const res = await api.get(`/api/promotion/${promotionId}/order-stats`);
      setOrderStats(res.data.data || null);
    } catch {
      setOrderStats(null);
    }
  };

  // Hàm mở popup xác nhận xóa
  const handleDeleteConfirm = async (promotion: Promotion) => {
    setPopupPromotion(promotion);
    setShowPopup(true);
    await fetchOrderStats(promotion.id);
  };

  // Hàm thực hiện xóa sau khi xác nhận
  const handleDelete = async () => {
    if (!popupPromotion) return;
    setDeletingId(popupPromotion.id);
    try {
      await api.delete(`/api/promotion/${popupPromotion.id}`);
      setPromotions((prev) => prev.filter((p) => p.id !== popupPromotion.id));
      setShowPopup(false);
      setOrderStats(null);
      setPopupPromotion(null);
    } catch (err) {
      alert("Delete failed!");
    } finally {
      setDeletingId(null);
    }
  };

  const totalPages = Math.ceil(promotions.length / PAGE_SIZE);
  const pagedPromotions = promotions.slice(
    (page - 1) * PAGE_SIZE,
    page * PAGE_SIZE
  );

  const handlePrev = () => setPage((p) => Math.max(1, p - 1));
  const handleNext = () => setPage((p) => Math.min(totalPages, p + 1));

  return (
    <>
      <PageBreadcrumb
        name="Promotions"
        title="Promotions"
        breadCrumbItems={["Fitmate", "Promotions"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header flex justify-between items-center">
            <h4 className="card-title">Promotion List</h4>
            <Link
              to="/admin/product/promotion/add"
              className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
            >
              <i className="mgc_add_circle_line me-2"></i> Add New Promotion
            </Link>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <>
                <table className="min-w-full table-auto border">
                  <thead>
                    <tr>
                      <th className="px-2 py-2 border">ID</th>
                      <th className="px-2 py-2 border">Name</th>
                      <th className="px-2 py-2 border">Discount (%)</th>
                      <th className="px-2 py-2 border">Start Date</th>
                      <th className="px-2 py-2 border">End Date</th>
                      <th className="px-2 py-2 border">Products</th>
                      <th className="px-2 py-2 border">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pagedPromotions.map((p) => (
                      <tr key={p.id}>
                        <td className="px-2 py-2 border">{p.id}</td>
                        <td className="px-2 py-2 border">{p.name}</td>
                        <td className="px-2 py-2 border">
                          {(p.discount * 100).toFixed(2)}
                        </td>
                        <td className="px-2 py-2 border">
                          {formatDate(p.startDate)}
                        </td>
                        <td className="px-2 py-2 border">
                          {formatDate(p.endDate)}
                        </td>
                        <td className="px-2 py-2 border">
                          {p.products && p.products.length > 0 ? (
                            <ul className="list-disc list-inside space-y-1">
                              {p.products.map((prod) => (
                                <li key={prod.productId}>
                                  <b>{prod.productName}</b>
                                  {prod.discountOverride !== null &&
                                    ` - Override: ${(
                                      prod.discountOverride * 100
                                    ).toFixed(1)}%`}
                                  <br />
                                  <small>
                                    {formatDate(prod.startDate)} →{" "}
                                    {formatDate(prod.endDate)}
                                  </small>
                                </li>
                              ))}
                            </ul>
                          ) : (
                            "No products"
                          )}
                        </td>
                        <td className="px-2 py-2 border">
                          <Link
                            to={`/admin/product/promotion/edit/${p.id}`}
                            className="me-2 text-blue-600"
                            title="Edit"
                          >
                            <i className="mgc_edit_line text-lg"></i>
                          </Link>
                          <button
                            className={`ms-2 text-red-600 ${
                              deletingId === p.id
                                ? "opacity-50 pointer-events-none"
                                : ""
                            }`}
                            title="Delete"
                            disabled={deletingId === p.id}
                            onClick={() => handleDeleteConfirm(p)}
                          >
                            <i className="mgc_delete_line text-lg"></i>
                          </button>
                        </td>
                      </tr>
                    ))}
                    {pagedPromotions.length === 0 && (
                      <tr>
                        <td colSpan={7} className="text-center py-4">
                          No promotions found.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
                {/* Pagination controls */}
                <div className="flex justify-end items-center gap-2 mt-4">
                  <button
                    className="btn btn-sm bg-gray-200"
                    onClick={handlePrev}
                    disabled={page === 1}
                  >
                    Prev
                  </button>
                  <span>
                    Page {page} of {totalPages}
                  </span>
                  <button
                    className="btn btn-sm bg-gray-200"
                    onClick={handleNext}
                    disabled={page === totalPages || totalPages === 0}
                  >
                    Next
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      </div>
      {/* Popup xác nhận xóa */}
      {showPopup && popupPromotion && (
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50">
          <div className="bg-white rounded shadow-lg p-6 w-full max-w-lg">
            <h4 className="font-bold text-lg mb-2 text-red-600">
              Confirm Delete Promotion
            </h4>
            <div className="mb-4">
              <span>
                Are you sure you want to delete promotion{" "}
                <b>{popupPromotion.name}</b>?
              </span>
              <br />
              {orderStats ? (
                orderStats.orderCount > 0 || orderStats.unpaidOrderCount > 0 ? (
                  <div className="mt-2">
                    <span className="text-red-500 font-semibold">
                      There are {orderStats.orderCount} orders,{" "}
                      {orderStats.orderDetailCount} products placed,
                      {orderStats.paidOrderCount} paid orders and{" "}
                      {orderStats.unpaidOrderCount} unpaid orders with this
                      promotion!
                    </span>
                    <table className="min-w-full border mt-2">
                      <thead>
                        <tr className="bg-gray-100">
                          <th className="p-2 border">Order Count</th>
                          <th className="p-2 border">Order Detail Count</th>
                          <th className="p-2 border">Paid Orders</th>
                          <th className="p-2 border">Unpaid Orders</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td className="p-2 border">
                            {orderStats.orderCount}
                          </td>
                          <td className="p-2 border">
                            {orderStats.orderDetailCount}
                          </td>
                          <td className="p-2 border">
                            {orderStats.paidOrderCount}
                          </td>
                          <td className="p-2 border">
                            {orderStats.unpaidOrderCount}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                    <div className="mt-4 text-red-600 font-semibold">
                      You cannot delete this promotion because there are related
                      orders or unpaid orders.
                    </div>
                  </div>
                ) : (
                  <div className="mt-2">
                    <span className="text-green-600">
                      There are no orders related to this promotion.
                    </span>
                    <table className="min-w-full border mt-2">
                      <thead>
                        <tr className="bg-gray-100">
                          <th className="p-2 border">Order Count</th>
                          <th className="p-2 border">Order Detail Count</th>
                          <th className="p-2 border">Paid Orders</th>
                          <th className="p-2 border">Unpaid Orders</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td className="p-2 border">
                            {orderStats.orderCount}
                          </td>
                          <td className="p-2 border">
                            {orderStats.orderDetailCount}
                          </td>
                          <td className="p-2 border">
                            {orderStats.paidOrderCount}
                          </td>
                          <td className="p-2 border">
                            {orderStats.unpaidOrderCount}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                )
              ) : (
                <span className="text-green-600">
                  There are no orders related to this promotion.
                </span>
              )}
            </div>
            <div className="flex justify-end gap-2 mt-4">
              <button
                className="btn bg-gray-200 text-gray-700"
                onClick={() => {
                  setShowPopup(false);
                  setOrderStats(null);
                  setPopupPromotion(null);
                }}
                disabled={deletingId !== null}
              >
                Cancel
              </button>
              {orderStats && orderStats.unpaidOrderCount === 0 && (
                <button
                  className="btn bg-red-600 text-white"
                  onClick={handleDelete}
                  disabled={deletingId !== null}
                >
                  {deletingId !== null ? "Deleting..." : "Delete"}
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Promotions;
