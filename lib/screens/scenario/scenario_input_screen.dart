// 상황 입력 화면 — 사용자가 연습할 상황, 난이도, 카테고리를 입력

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../providers/scenario_provider.dart';
import '../../router/app_router.dart';

class ScenarioInputScreen extends ConsumerStatefulWidget {
  const ScenarioInputScreen({super.key});

  @override
  ConsumerState<ScenarioInputScreen> createState() => _ScenarioInputScreenState();
}

class _ScenarioInputScreenState extends ConsumerState<ScenarioInputScreen> {
  final _situationController = TextEditingController();

  // 선택된 난이도 (기본값: intermediate)
  String _selectedDifficulty = 'intermediate';
  // 선택된 카테고리 (기본값: daily)
  String _selectedCategory = 'daily';

  // 난이도 선택지 (value: 표시 텍스트)
  final Map<String, String> _difficulties = {
    'beginner': '초급',
    'intermediate': '중급',
    'advanced': '고급',
  };

  // 카테고리 선택지
  final Map<String, String> _categories = {
    'daily': '일상',
    'business': '비즈니스',
    'travel': '여행',
    'academic': '학술',
  };

  @override
  void dispose() {
    _situationController.dispose();
    super.dispose();
  }

  // 시나리오 생성 버튼 클릭
  Future<void> _onGeneratePressed() async {
    final situation = _situationController.text.trim();
    if (situation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상황을 입력해주세요')),
      );
      return;
    }

    // ScenarioService 호출 (scenario_provider.dart를 통해)
    final scenario = await ref.read(scenarioGenerateProvider.notifier).generate(
          situation: situation,
          difficulty: _selectedDifficulty,
          category: _selectedCategory,
        );

    if (!mounted) return;
    if (scenario != null) {
      // 성공: 시나리오 결과 화면으로 이동, Scenario 객체를 extra로 전달
      context.push(AppRoutes.scenarioResult, extra: scenario);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시나리오 생성에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 상태 감시
    final generateState = ref.watch(scenarioGenerateProvider);
    final isLoading = generateState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('상황 입력'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상황 입력 텍스트 필드
              const Text(
                '어떤 상황을 연습하고 싶으신가요?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _situationController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: AppStrings.scenarioInputHint,
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 24),

              // 난이도 선택
              const Text(
                '난이도',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _difficulties.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: _selectedDifficulty == entry.key,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _selectedDifficulty == entry.key
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedDifficulty = entry.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // 카테고리 선택
              const Text(
                '카테고리',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: _selectedCategory == entry.key,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _selectedCategory == entry.key
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedCategory = entry.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // 시나리오 생성 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _onGeneratePressed,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    isLoading ? '생성 중...' : AppStrings.generateScenario,
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
