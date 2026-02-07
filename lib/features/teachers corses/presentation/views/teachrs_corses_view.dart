// import 'package:catalyst/core/utils/app_colors.dart';
// import 'package:catalyst/core/utils/routs.dart';
// import 'package:catalyst/core/widgets/app_bar.dart';
// import 'package:catalyst/core/widgets/base_scaffold.dart';
// import 'package:catalyst/core/widgets/liquid_glass.dart';
// import 'package:catalyst/features/drawer/drawer.dart';
// import 'package:catalyst/features/teachers%20corses/cubits/cubit/get_all_courses_state.dart';
// import 'package:catalyst/features/teachers%20corses/data/models/gwt_all_courses_model.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:catalyst/features/teachers%20corses/cubits/cubit/get_all_courses_cubit.dart';

// class CoursesView extends StatelessWidget {
//   const CoursesView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       drawer: const CustomDrawer(),
//       appBar: CustomAppBar(title: "Our Courses", centerTitle: true),

//       child: SafeArea(
//         child: SingleChildScrollView(
//           child: BlocConsumer<GetAllCoursesCubit, GetAllCoursesState>(
//             listener: (context, state) {
//               if (state is GetAllCoursesError) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text(state.message)));
//               }
//             },
//             builder: (context, state) {
//               return Stack(
//                 children: [
//                   Opacity(
//                     opacity: state is GetAllCoursesLoading ? 0.5 : 1,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: Column(
//                         children: [
//                           // Search Bar
//                           Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 prefixIcon: const Icon(
//                                   Icons.search,
//                                   color: Colors.white30,
//                                 ),
//                                 hintText: "Search by name or subject...",
//                                 hintStyle: const TextStyle(
//                                   color: Colors.white30,
//                                 ),
//                                 filled: true,
//                                 fillColor: AppColors.likeBlack,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 0,
//                                   horizontal: 12,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Teachers Grid
//                           TeachersGrid(
//                             lessons: (state is GetAllCoursesSuccess)
//                                 ? state.courses
//                                 : [],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (state is GetAllCoursesLoading)
//                     const Center(child: CircularProgressIndicator()),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TeachersGrid extends StatelessWidget {
//   final List<Lesson> lessons;

//   const TeachersGrid({super.key, required this.lessons});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisExtent: 250, // زودنا الطول شويه لتفادي overflow
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//       ),
//       itemCount: lessons.length,
//       itemBuilder: (context, index) {
//         final teacher = lessons[index];
//         return TeacherCard(
//           name: teacher.teacher.fullName,
//           subject: teacher.subject,
//           imageUrl: teacher.teacher.fullName,
//           onTap: () {
//             GoRouter.of(context).push(Routs.teacherCourses);
//           },
//         );
//       },
//     );
//   }
// }

// class TeacherCard extends StatelessWidget {
//   final String name;
//   final String subject;
//   final String imageUrl;
//   final VoidCallback? onTap;

//   const TeacherCard({
//     super.key,
//     required this.name,
//     required this.subject,
//     required this.imageUrl,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: onTap,
//       child: GlassBox(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(60),
//               child: Image.network(
//                 imageUrl,
//                 height: 80,
//                 width: 80,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               name,
//               textAlign: TextAlign.center,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               subject,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: Colors.grey,
//                 fontSize: 14,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
