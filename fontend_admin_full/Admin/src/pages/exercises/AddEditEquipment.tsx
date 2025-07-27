import React, { useEffect, useState, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";
import { toast } from "react-hot-toast";

const BASE_URL = config.API_URL;
const api = new APICore();

type EquipmentForm = {
  equipmentName: string;
  equipmentImage: File | null;
};

const AddEditEquipment = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState<EquipmentForm>({
    equipmentName: "",
    equipmentImage: null,
  });
  const [preview, setPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [showDeletePopup, setShowDeletePopup] = useState(false);
  const [exerciseCount, setExerciseCount] = useState<number>(0);

  useEffect(() => {
    if (isEdit) {
      fetchEquipment();
      checkIfUsedInExercises();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchEquipment = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/equipment/id/${id}`);
      const data = res.data.data;
      setForm({
        equipmentName: data.equipmentName || "",
        equipmentImage: null,
      });
      if (data.equipmentImage) {
        if (/^https?:\/\//i.test(data.equipmentImage)) {
          setPreview(data.equipmentImage);
        } else {
          setPreview(`${BASE_URL}/resources/${data.equipmentImage}`);
        }
      }
    } catch (err) {
      setErrors({ submit: "Failed to load equipment" });
    } finally {
      setLoading(false);
    }
  };

  const checkIfUsedInExercises = async () => {
    try {
      const res = await api.get(`/api/admin/equipment/${id}/exercise-count`);
      setExerciseCount(res.data.data || 0);
    } catch (err) {
      console.error("Failed to check exercise count", err);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, type, files, value } = e.target as any;
    if (type === "file") {
      setForm((prev) => ({
        ...prev,
        equipmentImage: files && files[0] ? files[0] : null,
      }));
      if (files && files[0]) {
        setPreview(URL.createObjectURL(files[0]));
      }
    } else {
      setForm((prev) => ({
        ...prev,
        [name]: value,
      }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrors({});
    const formData = new FormData();
    formData.append("equipmentName", form.equipmentName);
    if (form.equipmentImage) formData.append("equipmentImage", form.equipmentImage);

    try {
      let res;
      if (isEdit && id) {
        res = await api.update(`/api/admin/equipment/${id}`, formData);
      } else {
        res = await api.create("/api/admin/equipment/create", formData);
      }
      if (res?.data?.success === false && res?.data?.errors) {
        setErrors(res.data.errors);
      } else if (res?.data?.success === true) {
        toast.success("Saved successfully");
        navigate("/admin/exercise/equipments");
      } else {
        setErrors({ submit: res?.data?.message || "Save failed" });
      }
    } catch (err: any) {
      if (err?.response?.data?.errors) {
        setErrors(err.response.data.errors);
      } else {
        setErrors({ submit: err?.response?.data?.message || "Save failed" });
      }
    } finally {
      setLoading(false);
    }
  };

  const confirmDelete = async () => {
    if (!id) return;
    setLoading(true);
    try {
      await api.delete(`/api/admin/equipment/${id}`);
      toast.success("Deleted successfully");
      navigate("/admin/exercise/equipments");
    } catch (err: any) {
      toast.error(err?.response?.data?.message || "Delete failed");
    } finally {
      setLoading(false);
      setShowDeletePopup(false);
    }
  };

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Equipment" : "Add Equipment"}
        title={isEdit ? "Edit Equipment" : "Add Equipment"}
        breadCrumbItems={["Fitmate", "Equipments", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} Equipment</h4>
          </div>
          <div className="p-6">
            <form onSubmit={handleSubmit} className="flex flex-col gap-4" encType="multipart/form-data">
              <div>
                <label className="block mb-1 font-medium">Equipment Name</label>
                <input
                  type="text"
                  name="equipmentName"
                  value={form.equipmentName}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
                {errors.equipmentName && <div className="text-red-500">{errors.equipmentName}</div>}
              </div>
              <div>
                <label className="block mb-1 font-medium">Equipment Image</label>
                <input
                  type="file"
                  name="equipmentImage"
                  accept="image/*"
                  className="form-input w-full"
                  ref={fileInputRef}
                  onChange={handleChange}
                  disabled={loading}
                />
                {preview && (
                  <img src={preview} alt="Preview" className="mt-2 rounded w-32 h-32 object-cover" />
                )}
                {errors.equipmentImage && <div className="text-red-500">{errors.equipmentImage}</div>}
              </div>
              {errors.submit && <div className="text-red-500">{errors.submit}</div>}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/exercise/equipments")}
                  disabled={loading}
                >
                  Cancel
                </button>
                {isEdit && exerciseCount === 0 && (
                  <button
                    type="button"
                    onClick={() => setShowDeletePopup(true)}
                    className="btn bg-red-500 text-white"
                    disabled={loading}
                  >
                    Delete
                  </button>
                )}
                <button
                  type="submit"
                  className="btn bg-primary text-white"
                  disabled={loading}
                >
                  {isEdit ? "Update" : "Create"}
                </button>
              </div>
              {isEdit && exerciseCount > 0 && (
                <div className="text-sm text-gray-500 mt-2">
                  ⚠ This equipment is linked to {exerciseCount} exercise{exerciseCount > 1 ? "s" : ""} and cannot be deleted.
                </div>
              )}
            </form>
          </div>
        </div>
      </div>

      {showDeletePopup && (
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded shadow-lg w-[90%] max-w-md">
            <h2 className="text-lg font-semibold mb-4">Confirm Deletion</h2>
            <p>Are you sure you want to delete this equipment?</p>
            <div className="flex justify-end gap-3 mt-6">
              <button
                className="btn bg-gray-300"
                onClick={() => setShowDeletePopup(false)}
                disabled={loading}
              >
                Cancel
              </button>
              <button
                className="btn bg-red-500 text-white"
                onClick={confirmDelete}
                disabled={loading}
              >
                Yes, Delete
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default AddEditEquipment;
