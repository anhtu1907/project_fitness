import 'package:get_it/get_it.dart';

import 'export.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<BmiService>(BmiServiceImpl());
  sl.registerSingleton<MealService>(MealServiceImpl());
  sl.registerSingleton<ExerciseService>(ExerciseServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<BmiRepository>(BmiRepositoryImpl());
  sl.registerSingleton<MealRepository>(MealRepositoryImpl());
  sl.registerSingleton<ExerciseRepository>(ExerciseRepositoryImpl());
  // Usecases
  // Auth
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<ForgetPasswordUsecase>(ForgetPasswordUsecase());
  sl.registerSingleton<GetUserUsecase>(GetUserUsecase());
  sl.registerSingleton<IsLoggedUsecase>(IsLoggedUsecase());
  sl.registerSingleton<VerifyUsecase>(VerifyUsecase());
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase());
  sl.registerSingleton<GetUserByUsernameUseCase>(GetUserByUsernameUseCase());
  sl.registerSingleton<EnsureValidTokenUsecase>(EnsureValidTokenUsecase());
  // BMI
  sl.registerSingleton<GetAllDataByUserUseCase>(GetAllDataByUserUseCase());
  sl.registerSingleton<GetAllGoalByUserUseCase>(GetAllGoalByUserUseCase());
  sl.registerSingleton<SaveDataUsecase>(SaveDataUsecase());
  sl.registerSingleton<SaveGoalUsecase>(SaveGoalUsecase());
  sl.registerSingleton<CheckBmiUsecase>(CheckBmiUsecase());
  sl.registerSingleton<CheckBmiGoalUsecase>(CheckBmiGoalUsecase());
  // Meal
  sl.registerSingleton<SaveRecordMealUseCase>(SaveRecordMealUseCase());
  sl.registerSingleton<DeleteRecordMealUseCase>(DeleteRecordMealUseCase());
  sl.registerSingleton<DeleteAllRecordMealUseCase>(
      DeleteAllRecordMealUseCase());
  sl.registerSingleton<GetMealBySubCategoryUseCase>(
      GetMealBySubCategoryUseCase());
  sl.registerSingleton<GetAllCategoryUseCase>(GetAllCategoryUseCase());
  sl.registerSingleton<GetAllSubCategoryUseCase>(GetAllSubCategoryUseCase());
  sl.registerSingleton<SearchByMealNameUseCase>(SearchByMealNameUseCase());
  sl.registerSingleton<GetAllMealUseCase>(GetAllMealUseCase());
  sl.registerSingleton<GetAllRecordMealUseCase>(GetAllRecordMealUseCase());
  sl.registerSingleton<GetMealById>(GetMealById());

  // Exercise
  sl.registerSingleton<GetExerciseSubCategoryUseCase>(
      GetExerciseSubCategoryUseCase());
  sl.registerSingleton<GetExerciseBySubCategoryUseCase>(
      GetExerciseBySubCategoryUseCase());
  sl.registerSingleton<GetExerciseByIdUseCase>(GetExerciseByIdUseCase());
  sl.registerSingleton<DeleteScheduleUseCase>(DeleteScheduleUseCase());
  sl.registerSingleton<DeleteAllScheduleByTimeUseCase>(
      DeleteAllScheduleByTimeUseCase());
  sl.registerSingleton<GetExercisesUseCase>(GetExercisesUseCase());
  sl.registerSingleton<GetExerciseProgressUseCase>(
      GetExerciseProgressUseCase());
  sl.registerSingleton<GetExerciseScheduleUseCase>(
      GetExerciseScheduleUseCase());
  sl.registerSingleton<GetExerciseSessionUseCase>(GetExerciseSessionUseCase());
  sl.registerSingleton<GetExerciseResultUseCase>(GetExerciseResultUseCase());
  sl.registerSingleton<GetExerciseCategoryUseCase>(
      GetExerciseCategoryUseCase());
  sl.registerSingleton<StartExerciseUseCase>(StartExerciseUseCase());
  sl.registerSingleton<ScheduleExerciseUseCase>(ScheduleExerciseUseCase());
  sl.registerSingleton<GetSessionResetBatchUseCase>(GetSessionResetBatchUseCase());


  sl.registerLazySingleton<ExerciseScheduleCubit>(
      () => ExerciseScheduleCubit());

  // Exercise Favorite
  sl.registerSingleton<GetFavoritesUseCase>(GetFavoritesUseCase());
  sl.registerSingleton<GetExerciseFavoriteUseCase>(GetExerciseFavoriteUseCase());
  sl.registerSingleton<AddFavoriteUsecase>(AddFavoriteUsecase());
  sl.registerSingleton<AddExerciseFavoriteUseCase>(
      AddExerciseFavoriteUseCase());
  sl.registerSingleton<RemoveFavoriteUseCase>(RemoveFavoriteUseCase());
  sl.registerSingleton<RemoveExerciseFavoriteUseCase>(RemoveExerciseFavoriteUseCase());


  // Sub Category - Program
  sl.registerSingleton<GetSubCategoryProgramUseCase>(GetSubCategoryProgramUseCase());

  // Exercise Mode
  sl.registerSingleton<GetExerciseModeUseCase>(GetExerciseModeUseCase());
  // Search
  sl.registerSingleton<SearchBySubCategoryNameUseCase>(SearchBySubCategoryNameUseCase());
  // Equipment
  // sl.registerSingleton<GetExerciseEquipmentUseCase>(GetExerciseEquipmentUseCase());
  sl.registerSingleton<GetEquipmentBySubIdUseCase>(GetEquipmentBySubIdUseCase());
  sl.registerSingleton<GetAllEquipmentUseCase>(GetAllEquipmentUseCase());
}
