import React, { useState, useEffect, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";
import Select from "react-select";

const BASE_URL = config.API_URL;
const api = new APICore();

const initialState = {
  mealName: "",
  mealImage: null as File | null,
  weight: "",
  kcal: "",
  protein: "",
  fat: "",
  carbonhydrate: "",
  fiber: "",
  sugar: "",
  subCategoryIds: [] as number[],
  timeOfDayIds: [] as number[],
};

const AddEditMeal = () => {
  const [form, setForm] = useState(initialState);
  const [preview, setPreview] = useState<string | null>(null);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [loading, setLoading] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const [subCategories, setSubCategories] = useState<any[]>([]);
  const [mealTimes, setMealTimes] = useState<any[]>([]);
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    api
      .get("/api/admin/meal-subcategory")
      .then((res: any) => setSubCategories(res.data.data || []));
    api
      .get("/api/admin/meal-times")
      .then((res: any) => setMealTimes(res.data.data || []));
  }, []);

  useEffect(() => {
    if (id) {
      setIsEdit(true);
      api.get(`/api/admin/meals/${id}`).then((res: any) => {
        const data = res.data.data;
        setForm({
          mealName: data.mealName || "",
          mealImage: null,
          weight: data.weight?.toString() || "",
          kcal: data.kcal?.toString() || "",
          protein: data.protein?.toString() || "",
          fat: data.fat?.toString() || "",
          carbonhydrate: data.carbonhydrate?.toString() || "",
          fiber: data.fiber?.toString() || "",
          sugar: data.sugar?.toString() || "",
          subCategoryIds: data.subCategoryIds || [],
          timeOfDayIds: data.timeOfDayIds || [],
        });
        if (data.mealImage) {
          if (/^https?:\/\//i.test(data.mealImage)) {
            setPreview(data.mealImage);
          } else {
            setPreview(`${BASE_URL}/resources/${data.mealImage}`);
          }
        }
      });
    }
  }, [id]);

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value, type } = e.target;
    if (type === "file") {
      const file = (e.target as HTMLInputElement).files?.[0] || null;
      setForm((prev) => ({ ...prev, mealImage: file }));
      if (file) {
        setPreview(URL.createObjectURL(file));
      }
    } else {
      setForm((prev) => ({ ...prev, [name]: value }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrors({});
    const formData = new FormData();
    formData.append("mealName", form.mealName);
    formData.append("weight", form.weight);
    formData.append("kcal", form.kcal);
    formData.append("protein", form.protein || "0");
    formData.append("fat", form.fat || "0");
    formData.append("carbonhydrate", form.carbonhydrate || "0");
    formData.append("fiber", form.fiber || "0");
    formData.append("sugar", form.sugar || "0");
    if (form.mealImage) formData.append("mealImage", form.mealImage);
    form.subCategoryIds.forEach((id) =>
      formData.append("subCategoryIds", id.toString())
    );
    form.timeOfDayIds.forEach((id) =>
      formData.append("timeOfDayIds", id.toString())
    );

    try {
      let res;
      if (isEdit && id) {
        res = await api.update(`/api/admin/meals/${id}`, formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      } else {
        res = await api.create("/api/admin/meals/create", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      }
      // Kiểm tra lỗi trả về từ backend
      if (res?.data?.success === false && res?.data?.errors) {
        setErrors(res.data.errors);
      } else if (res?.data?.success === true) {
        navigate("/admin/meal/meals");
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

  const subCategoryOptions = subCategories.map((s) => ({
    value: s.id,
    label: s.subCategoryName,
  }));
  const mealTimeOptions = mealTimes.map((t) => ({
    value: t.id,
    label: t.timeName,
  }));

  return (
    <>
      <PageBreadcrumb
        title={isEdit ? "Edit Meal" : "Add Meal"}
        name={isEdit ? "Edit Meal" : "Add Meal"}
        breadCrumbItems={[
          "Fitmate",
          "Meals",
          isEdit ? "Edit Meal" : "Add Meal",
        ]}
      />
      <div className="col-span-12 mx-auto">
        <form
          className="card p-8 col-span-12 space-y-6"
          onSubmit={handleSubmit}
          encType="multipart/form-data"
        >
          <h2 className="text-xl font-semibold mb-4">
            {isEdit ? "Edit Meal" : "Add New Meal"}
          </h2>
          {errors.submit && <div className="text-red-500">{errors.submit}</div>}
          <div>
            <label className="block font-medium mb-1">
              Meal Name<span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              name="mealName"
              className="form-input w-full"
              value={form.mealName}
              onChange={handleChange}
              disabled={loading}
            />
            {errors.mealName && (
              <div className="text-red-500">{errors.mealName}</div>
            )}
          </div>
          <div>
            <label className="block font-medium mb-1">Image</label>
            <input
              type="file"
              name="mealImage"
              accept="image/*"
              className="form-input w-full"
              ref={fileInputRef}
              onChange={handleChange}
              disabled={loading}
            />
            {preview && (
              <img
                src={preview}
                alt="Preview"
                className="mt-2 rounded w-32 h-32 object-cover"
              />
            )}
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block font-medium mb-1">
                Weight<span className="text-red-500">*</span>
              </label>
              <input
                type="number"
                name="weight"
                className="form-input w-full"
                value={form.weight}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.weight && (
                <div className="text-red-500">{errors.weight}</div>
              )}
            </div>
            <div>
              <label className="block font-medium mb-1">
                Kcal<span className="text-red-500">*</span>
              </label>
              <input
                type="number"
                name="kcal"
                className="form-input w-full"
                value={form.kcal}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.kcal && <div className="text-red-500">{errors.kcal}</div>}
            </div>
          </div>
          <div className="grid grid-cols-3 gap-4">
            <div>
              <label className="block font-medium mb-1">Protein</label>
              <input
                type="number"
                name="protein"
                className="form-input w-full"
                value={form.protein}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.protein && (
                <div className="text-red-500">{errors.protein}</div>
              )}
            </div>
            <div>
              <label className="block font-medium mb-1">Fat</label>
              <input
                type="number"
                name="fat"
                className="form-input w-full"
                value={form.fat}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.fat && <div className="text-red-500">{errors.fat}</div>}
            </div>
            <div>
              <label className="block font-medium mb-1">Carbohydrate</label>
              <input
                type="number"
                name="carbonhydrate"
                className="form-input w-full"
                value={form.carbonhydrate}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.carbonhydrate && (
                <div className="text-red-500">{errors.carbonhydrate}</div>
              )}
            </div>
            <div>
              <label className="block font-medium mb-1">Fiber</label>
              <input
                type="number"
                name="fiber"
                className="form-input w-full"
                value={form.fiber}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.fiber && (
                <div className="text-red-500">{errors.fiber}</div>
              )}
            </div>
            <div>
              <label className="block font-medium mb-1">Sugar</label>
              <input
                type="number"
                name="sugar"
                className="form-input w-full"
                value={form.sugar}
                onChange={handleChange}
                min={0}
                step="0.01"
                disabled={loading}
              />
              {errors.sugar && (
                <div className="text-red-500">{errors.sugar}</div>
              )}
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">
              Subcategories<span className="text-red-500">*</span>
            </label>
            <Select
              name="subCategoryIds"
              className="basic-multi-select"
              classNamePrefix="select"
              options={subCategoryOptions}
              isMulti
              value={subCategoryOptions.filter((opt) =>
                form.subCategoryIds.includes(opt.value)
              )}
              onChange={(options) =>
                setForm((prev) => ({
                  ...prev,
                  subCategoryIds: options
                    ? options.map((opt: any) => opt.value)
                    : [],
                }))
              }
              isClearable={false}
              isDisabled={loading}
            />
            {errors.subCategoryIds && (
              <div className="text-red-500">{errors.subCategoryIds}</div>
            )}
          </div>
          <div>
            <label className="block font-medium mb-1">
              Meal Times<span className="text-red-500">*</span>
            </label>
            <Select
              name="timeOfDayIds"
              className="basic-multi-select"
              classNamePrefix="select"
              options={mealTimeOptions}
              isMulti
              value={mealTimeOptions.filter((opt) =>
                form.timeOfDayIds.includes(opt.value)
              )}
              onChange={(options) =>
                setForm((prev) => ({
                  ...prev,
                  timeOfDayIds: options
                    ? options.map((opt: any) => opt.value)
                    : [],
                }))
              }
              isClearable={false}
              isDisabled={loading}
            />
            {errors.timeOfDayIds && (
              <div className="text-red-500">{errors.timeOfDayIds}</div>
            )}
          </div>
          <div className="flex justify-end gap-2">
            <button
              type="button"
              className="btn bg-gray-200 text-gray-700"
              onClick={() => navigate("/meals")}
              disabled={loading}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn bg-primary text-white"
              disabled={loading}
            >
              {loading
                ? isEdit
                  ? "Saving..."
                  : "Saving..."
                : isEdit
                ? "Update"
                : "Save"}
            </button>
          </div>
        </form>
      </div>
    </>
  );
};

export default AddEditMeal;
