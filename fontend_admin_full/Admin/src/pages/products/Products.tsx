import React, { useEffect, useState } from "react";
import { Grid } from "gridjs-react";
import { html } from "gridjs";
import "gridjs/dist/theme/mermaid.min.css";
import { PageBreadcrumb } from "../../components";
import { fetchProducts, Product } from "./data";
import config from "../../config";
import { Link } from "react-router-dom";
import { APICore } from "../../helpers/api/apiCore";

declare global {
  interface Window {
    handleDeleteProduct?: (id: number) => void;
  }
}

const BASE_URL = config.API_URL;
const IMAGE_BASE_URL = BASE_URL + "/resources/";
const api = new APICore();

type ProductOrderStats = {
  orderCount: number;
  orderDetailCount: number;
  paidOrderCount: number;
  unpaidOrderCount: number;
};

const Products = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [supplierMap, setSupplierMap] = useState<{ [key: number]: string }>({});
  const [equipmentMap, setEquipmentMap] = useState<{ [key: number]: string }>({});
  const [supplementMap, setSupplementMap] = useState<{ [key: number]: string }>({});
  const [showPopup, setShowPopup] = useState(false);
  const [popupProduct, setPopupProduct] = useState<Product | null>(null);
  const [orderStats, setOrderStats] = useState<ProductOrderStats | null>(null);
  const [deletingId, setDeletingId] = useState<number | null>(null);
  const [productOrderCountMap, setProductOrderCountMap] = useState<{ [key: number]: number }>({});

  useEffect(() => {
    fetchProducts()
      .then((data) => setProducts(data || []))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    Promise.all([fetchSuppliers(), fetchEquipments(), fetchSupplements()]).then(
      ([suppliers, equipments, supplements]) => {
        setSupplierMap(Object.fromEntries(suppliers.map((s: any) => [s.id, s.name])));
        setEquipmentMap(Object.fromEntries(equipments.map((e: any) => [e.id, e.name])));
        setSupplementMap(Object.fromEntries(supplements.map((s: any) => [s.id, s.name])));
      }
    );
  }, []);

  useEffect(() => {
    if (products.length > 0) {
      const fetchCounts = async () => {
        const countMap: { [key: number]: number } = {};
        for (const product of products) {
          const count = await fetchProductOrderCount(product.id);
          countMap[product.id] = count;
        }
        setProductOrderCountMap(countMap);
      };
      fetchCounts();
    }
  }, [products]);

  const fetchSuppliers = async () => {
    const res = await api.get("/api/supplier");
    return res.data.data || [];
  };

  const fetchEquipments = async () => {
    const res = await api.get("/api/equipment");
    return res.data.data || [];
  };

  const fetchSupplements = async () => {
    const res = await api.get("/api/supplement");
    return res.data.data || [];
  };

  const truncateDescription = (desc: string, maxWords = 15) => {
    if (!desc) return "";
    const words = desc.split(/\s+/);
    if (words.length <= maxWords) return desc;
    return words.slice(0, maxWords).join(" ") + " ...";
  };

  const fetchOrderStats = async (productId: number) => {
    try {
      const res = await api.get(`/api/product/${productId}/order-stats`);
      setOrderStats(res.data.data || null);
    } catch {
      setOrderStats(null);
    }
  };

  const fetchProductOrderCount = async (productId: number): Promise<number> => {
    try {
      const res = await api.get(`/api/order-detail/count-by-product/${productId}`);
      return res.data.data || 0;
    } catch {
      return 0;
    }
  };

  const handleDeleteConfirm = async (product: Product) => {
    setPopupProduct(product);
    await fetchOrderStats(product.id);
    setShowPopup(true);
  };

  const handleDeleteProduct = async (id: number) => {
    if (!popupProduct) return;
    setDeletingId(id);
    try {
      await api.delete(`/api/product/${id}`);
      setProducts((prev) => prev.filter((p) => p.id !== id));
      setShowPopup(false);
      setOrderStats(null);
      setPopupProduct(null);
    } catch (err: any) {
      const errorMsg = err?.response?.data?.message || "Delete failed due to unknown error";
      alert(errorMsg);
    } finally {
      setDeletingId(null);
    }
  };

  const getActionHtml = (p: Product) => {
    const canDelete = (productOrderCountMap[p.id] ?? 0) === 0;
    return html(`
    <span class="inline-flex" style="min-width:70px;max-width:140px;">
      <a href="/admin/product/edit/${p.id}" class="me-2" title="Edit">
        <i class="mgc_edit_line text-lg"></i>
      </a>
      ${
        canDelete
          ? `<button class="ms-2 text-red-600" title="Delete" onclick="window.handleDeleteProduct && window.handleDeleteProduct(${p.id})">
              <i class="mgc_delete_line text-lg"></i>
            </button>`
          : `<a class="ms-2 " title="Delete" tabindex="-1" aria-disabled="true" onclick="event.preventDefault();">
              <i class="mgc_delete_line text-lg text-gray-300"></i>
            </a>`
      }
    </span>
  `);
  };

  useEffect(() => {
    window.handleDeleteProduct = (id: number) => {
      const product = products.find((p) => p.id === id);
      if (product) handleDeleteConfirm(product);
    };
    return () => {
      delete window.handleDeleteProduct;
    };
  }, [products]);

  return (
    <>
      {/* Breadcrumb & Card */}
      <PageBreadcrumb
        name="Product Management"
        title="Product Management"
        breadCrumbItems={["Fitmate", "Products", "Products"]}
      />

      <div className="flex flex-col gap-6">
        <div className="card">
          <div className="card-header">
            <div className="flex justify-between items-center">
              <h4 className="card-title">Product List</h4>
              <Link
                to="/admin/product/add"
                className="btn bg-primary/20 text-sm font-medium text-primary hover:text-white hover:bg-primary"
              >
                <i className="mgc_add_circle_line me-2"></i> Add New Product
              </Link>
            </div>
          </div>
          <div className="p-6">
            {loading ? (
              <div className="text-center py-8">Loading...</div>
            ) : (
              <Grid
                data={products.map((p) => {
                  const supplier = supplierMap[p.supplier ?? -1] || "";
                  const promotionText = (p.promotions || []).map((promo) => promo.promotionName).join(", ");

                  return [
                    p.id,
                    p.image
                      ? html(`<img src="${IMAGE_BASE_URL + p.image}" alt="${p.name}" style="width:80px;height:80px;object-fit:cover;border-radius:8px;" />`)
                      : "",
                    p.name,
                    truncateDescription(p.description),
                    p.price,
                    p.stock,
                    supplier,
                    promotionText,
                    getActionHtml(p),
                  ];
                })}
                columns={[
                  { name: "ID", width: "5%" },
                  { name: "Image", width: "8%" },
                  "Name",
                  "Description",
                  { name: "Price", width: "6%" },
                  { name: "Stock", width: "6%" },
                  { name: "Supplier", width: "10%" },
                  { name: "Promotion", width: "12%" },
                  { name: "Action", width: "6%" },
                ]}
                pagination={{ enabled: true, limit: 5 }}
                search={true}
                sort={true}
              />
            )}
          </div>
        </div>
      </div>

      {/* Confirm Delete Popup */}
      {showPopup && popupProduct && (
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50">
          <div className="bg-white rounded shadow-lg p-6 w-full max-w-lg">
            <h4 className="font-bold text-lg mb-2 text-red-600">Confirm Delete Product</h4>
            <div className="mb-4">
              <span>Are you sure you want to delete product <b>{popupProduct.name}</b>?</span>
              <br />
              {orderStats ? (
                orderStats.orderCount > 0 || orderStats.unpaidOrderCount > 0 ? (
                  <div className="mt-2 text-red-500 font-semibold">
                    There are {orderStats.orderCount} orders, {orderStats.orderDetailCount} products placed, {orderStats.paidOrderCount} paid orders and {orderStats.unpaidOrderCount} unpaid orders with this product!
                  </div>
                ) : (
                  <div className="mt-2 text-green-600">
                    There are no orders related to this product.
                  </div>
                )
              ) : (
                <span className="text-gray-500 text-sm mt-2">Loading order stats...</span>
              )}
            </div>
            <div className="flex justify-end gap-2 mt-4">
              <button
                className="btn bg-gray-200 text-gray-700"
                onClick={() => {
                  setShowPopup(false);
                  setOrderStats(null);
                  setPopupProduct(null);
                }}
                
              >
                Cancel
              </button>
              {
                <button
                  className="btn bg-red-600 text-white"
                  onClick={() => handleDeleteProduct(popupProduct.id)}
                  
                >
                  {deletingId !== null ? "Deleting..." : "Delete"}
                </button>
              }
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Products;
