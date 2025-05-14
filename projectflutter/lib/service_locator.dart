import 'package:get_it/get_it.dart';
import 'package:projectflutter/data/auth/repository/auth_repository_impl.dart';
import 'package:projectflutter/data/auth/source/auth_service.dart';
import 'package:projectflutter/data/bmi/repository/bmi_repository_impl.dart';
import 'package:projectflutter/data/bmi/source/bmi_service.dart';
import 'package:projectflutter/data/exercise/repository/exercise_repository_impl.dart';
import 'package:projectflutter/data/exercise/service/exercise_service.dart';
import 'package:projectflutter/data/meal/repository/meal_repository_impl.dart';
import 'package:projectflutter/data/meal/service/meal_service.dart';
import 'package:projectflutter/data/run/repository/run_repository_impl.dart';
import 'package:projectflutter/data/run/source/run_service.dart';
import 'package:projectflutter/domain/auth/repository/auth_repository.dart';
import 'package:projectflutter/domain/auth/usecase/forget_password_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/get_user_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/is_logged_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/logout_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/signin_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/signup_usecase.dart';
import 'package:projectflutter/domain/auth/usecase/verify_usecase.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/domain/bmi/usecase/check_bmi_usecase.dart';
import 'package:projectflutter/domain/bmi/usecase/save_data_usecase.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_by_sub_category.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_by_id.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_category.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_sub_category.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_progress.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_result.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_session.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercises.dart';
import 'package:projectflutter/domain/exercise/usecase/start_exercise.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/domain/meal/usecase/delete_all_record_meal.dart';
import 'package:projectflutter/domain/meal/usecase/delete_record_meal.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_category.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_sub_category.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_sub_category.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_id.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_meal.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_record_meal.dart';
import 'package:projectflutter/domain/meal/usecase/save_record_meal.dart';
import 'package:projectflutter/domain/meal/usecase/search_by_meal_name.dart';
import 'package:projectflutter/domain/run/repository/run_repository.dart';
import 'package:projectflutter/domain/run/usecase/get_record_run_by_user.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  // Services
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<BmiService>(BmiServiceImpl());
  sl.registerSingleton<MealService>(MealServiceImpl());
  sl.registerSingleton<ExerciseService>(ExerciseServiceImpl());
  sl.registerSingleton<RunService>(RunServiceImpl());
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<BmiRepository>(BmiRepositoryImpl());
  sl.registerSingleton<MealRepository>(MealRepositoryImpl());
  sl.registerSingleton<ExerciseRepository>(ExerciseRepositoryImpl());
  sl.registerSingleton<RunRepository>(RunRepositoryImpl());
  // Usecases
  // Auth
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<ForgetPasswordUsecase>(ForgetPasswordUsecase());
  sl.registerSingleton<GetUserUsecase>(GetUserUsecase());
  sl.registerSingleton<IsLoggedUsecase>(IsLoggedUsecase());
  sl.registerSingleton<VerifyUsecase>(VerifyUsecase());
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase());

  // BMI
  sl.registerSingleton<SaveDataUsecase>(SaveDataUsecase());
  sl.registerSingleton<CheckBmiUsecase>(CheckBmiUsecase());

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
  sl.registerSingleton<GetExercisesUseCase>(GetExercisesUseCase());
  sl.registerSingleton<GetExerciseProgressUseCase>(
      GetExerciseProgressUseCase());
  sl.registerSingleton<GetExerciseSessionUseCase>(GetExerciseSessionUseCase());
  sl.registerSingleton<GetExerciseResultUseCase>(GetExerciseResultUseCase());
  sl.registerSingleton<GetExerciseCategoryUseCase>(
      GetExerciseCategoryUseCase());
  sl.registerSingleton<StartExerciseUseCase>(StartExerciseUseCase());

  // Exercise Total Kcal
  sl.registerSingleton<GetRecordRunByUserUseCase>(GetRecordRunByUserUseCase());
}
