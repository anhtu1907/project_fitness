import React, { useEffect, useState, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { PageBreadcrumb } from "../../components";
import { APICore } from "../../helpers/api/apiCore";
import config from "../../config";
import Select from "react-select";

const BASE_URL = config.API_URL;
const api = new APICore();

type ExerciseForm = {
  exerciseName: string;
  exerciseImage: File | null;
  description: string;
  duration: number | "";
  kcal: number | "";
  subCategoryIds: number[];
  equipmentId: number | "";
  modeIds: number[];
};

const AddEditExercise = () => {
  const { id } = useParams<{ id: string }>();
  const isEdit = !!id;
  const navigate = useNavigate();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [form, setForm] = useState<ExerciseForm>({
    exerciseName: "",
    exerciseImage: null,
    description: "",
    duration: "",
    kcal: "",
    subCategoryIds: [],
    equipmentId: "",
    modeIds: [],
  });
  const [preview, setPreview] = useState<string | null>(null);
  const [subCategories, setSubCategories] = useState<any[]>([]);
  const [equipments, setEquipments] = useState<any[]>([]);
  const [modes, setModes] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    api
      .get("/api/admin/exercise-sub-category")
      .then((res: any) => setSubCategories(res.data.data || []));
    api
      .get("/api/admin/equipment")
      .then((res: any) => setEquipments(res.data.data || []));
    api
      .get("/api/admin/exercise-mode")
      .then((res: any) => setModes(res.data.data || []));
    if (isEdit) {
      fetchExercise();
    }
    // eslint-disable-next-line
  }, [id]);

  const fetchExercise = async () => {
    setLoading(true);
    try {
      const res = await api.get(`/api/admin/exercises/${id}`);
      const data = res.data.data;
      setForm({
        exerciseName: data.exerciseName || "",
        exerciseImage: null,
        description: data.description || "",
        duration: data.duration || "",
        kcal: data.kcal || "",
        subCategoryIds: Array.from(data.subCategoryIds || []),
        equipmentId: data.equipmentId || "",
        modeIds: data.modeIds || [],
      });
      if (data.exerciseImage) {
        if (/^https?:\/\//i.test(data.exerciseImage)) {
          setPreview(data.exerciseImage);
        } else {
          setPreview(`${BASE_URL}/resources/${data.exerciseImage}`);
        }
      }
    } catch (err) {
      setErrors({ submit: "Failed to load exercise" });
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >
  ) => {
    const { name, value, type, files } = e.target as any;
    if (type === "file") {
      setForm((prev) => ({
        ...prev,
        exerciseImage: files && files[0] ? files[0] : null,
      }));
      if (files && files[0]) {
        setPreview(URL.createObjectURL(files[0]));
      }
    } else if (
      name === "duration" ||
      name === "kcal" ||
      name === "equipmentId" ||
      name === "modeIds"
    ) {
      setForm((prev) => ({
        ...prev,
        [name]: value === "" ? "" : Number(value),
      }));
    } else {
      setForm((prev) => ({
        ...prev,
        [name]: value,
      }));
    }
  };

  const handleSubCategoryChange = (options: any) => {
    setForm((prev) => ({
      ...prev,
      subCategoryIds: options ? options.map((opt: any) => opt.value) : [],
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrors({});

    // Kiểm tra dữ liệu trước khi gửi
    if (
      !form.exerciseName ||
      !form.description ||
      !form.duration ||
      !form.kcal
    ) {
      setErrors({
        exerciseName: !form.exerciseName ? "Exercise name is required" : "",
        description: !form.description ? "Description is required" : "",
        duration: !form.duration ? "Duration is required" : "",
        kcal: !form.kcal ? "Kcal is required" : "",
      });
      setLoading(false);
      return;
    }

    const formData = new FormData();
    formData.append("exerciseName", form.exerciseName);
    if (form.exerciseImage)
      formData.append("exerciseImage", form.exerciseImage);
    formData.append("description", form.description);
    formData.append("duration", String(form.duration));
    formData.append("kcal", String(form.kcal));
    form.subCategoryIds.forEach((id) =>
      formData.append("subCategoryIds", id.toString())
    );
    formData.append("equipmentId", String(form.equipmentId));
    form.modeIds.forEach((id) => formData.append("modeIds", id.toString()));

    for (let pair of formData.entries()) {
      console.log(pair[0], pair[1]);
    }

    try {
      let res;
      if (isEdit && id) {
        res = await api.update(`/api/admin/exercises/${id}`, formData);
      } else {
        res = await api.create("/api/admin/exercises/create", formData);
      }
      if (res?.data?.success === false && res?.data?.errors) {
        setErrors(res.data.errors);
      } else if (res?.data?.success === true) {
        navigate("/admin/exercise/exercises");
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

  const equipmentOptions = equipments.map((e) => ({
    value: e.id,
    label: e.equipmentName,
  }));

  const modeOptions = modes.map((m) => ({
    value: m.id,
    label: m.modeName,
  }));

  return (
    <>
      <PageBreadcrumb
        name={isEdit ? "Edit Exercise" : "Add Exercise"}
        title={isEdit ? "Edit Exercise" : "Add Exercise"}
        breadCrumbItems={["Fitmate", "Exercises", isEdit ? "Edit" : "Add"]}
      />
      <div className="flex flex-col gap-6">
        <div className="card w-full mx-auto">
          <div className="card-header">
            <h4 className="card-title">{isEdit ? "Edit" : "Add"} Exercise</h4>
          </div>
          <div className="p-6">
            <form
              onSubmit={handleSubmit}
              className="flex flex-col gap-4"
              encType="multipart/form-data"
            >
              <div>
                <label className="block mb-1 font-medium">Exercise Name</label>
                <input
                  type="text"
                  name="exerciseName"
                  value={form.exerciseName}
                  onChange={handleChange}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
                {errors.exerciseName && (
                  <div className="text-red-500">{errors.exerciseName}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">Exercise Image</label>
                <input
                  type="file"
                  name="exerciseImage"
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
                {errors.exerciseImage && (
                  <div className="text-red-500">{errors.exerciseImage}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">Description</label>
                <textarea
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  className="form-input w-full"
                  rows={3}
                  required
                  disabled={loading}
                />
                {errors.description && (
                  <div className="text-red-500">{errors.description}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">
                  Duration (minutes)
                </label>
                <input
                  type="number"
                  name="duration"
                  value={form.duration}
                  onChange={handleChange}
                  min={1}
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
                {errors.duration && (
                  <div className="text-red-500">{errors.duration}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">Kcal</label>
                <input
                  type="number"
                  name="kcal"
                  value={form.kcal}
                  onChange={handleChange}
                  min={1}
                  step="0.01"
                  className="form-input w-full"
                  required
                  disabled={loading}
                />
                {errors.kcal && (
                  <div className="text-red-500">{errors.kcal}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">Subcategories</label>
                <Select
                  name="subCategoryIds"
                  className="basic-multi-select"
                  classNamePrefix="select"
                  options={subCategoryOptions}
                  isMulti
                  value={subCategoryOptions.filter((opt) =>
                    form.subCategoryIds.includes(opt.value)
                  )}
                  onChange={handleSubCategoryChange}
                  isClearable={false}
                  isDisabled={loading}
                />
                {errors.subCategoryIds && (
                  <div className="text-red-500">{errors.subCategoryIds}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">Equipment</label>
                <select
                  name="equipmentId"
                  value={form.equipmentId}
                  onChange={handleChange}
                  className="form-input w-full"
                  disabled={loading}
                >
                  <option value="">Select equipment</option>
                  {equipmentOptions.map((e) => (
                    <option key={e.value} value={e.value}>
                      {e.label}
                    </option>
                  ))}
                </select>
                {errors.equipmentId && (
                  <div className="text-red-500">{errors.equipmentId}</div>
                )}
              </div>
              <div>
                <label className="block mb-1 font-medium">Mode</label>
                <Select
                  name="modeIds"
                  className="basic-multi-select"
                  classNamePrefix="select"
                  options={modeOptions}
                  isMulti
                  value={modeOptions.filter((opt) =>
                    form.modeIds.includes(opt.value)
                  )}
                  onChange={(options) =>
                    setForm((prev) => ({
                      ...prev,
                      modeIds: options
                        ? options.map((opt: any) => opt.value)
                        : [],
                    }))
                  }
                  isDisabled={loading}
                />
                {errors.modeIds && (
                  <div className="text-red-500">{errors.modeId}</div>
                )}
              </div>
              {errors.submit && (
                <div className="text-red-500">{errors.submit}</div>
              )}
              <div className="flex gap-2 justify-end">
                <button
                  type="button"
                  className="btn bg-gray-200"
                  onClick={() => navigate("/admin/exercise/exercises")}
                  disabled={loading}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn bg-primary text-white"
                  disabled={loading}
                >
                  {isEdit ? "Update" : "Create"}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </>
  );
};

export default AddEditExercise;
