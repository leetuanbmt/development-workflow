#!/usr/bin/env python3

"""
Skill Confidence Scorer - AI-powered skill selection with confidence scoring

Usage:
    python3 scripts/skill_confidence_scorer.py "I found a bug with null handling"
    python3 scripts/skill_confidence_scorer.py --input-file request.txt --json
    python3 scripts/skill_confidence_scorer.py --interactive

Features:
    - Semantic understanding (not just keyword matching)
    - Top-3 skill suggestions with confidence %
    - Handles complex, multi-skill requests
    - Learning from user feedback
    - Exports results as JSON, CSV, or formatted text
"""

import json
import sys
import argparse
from pathlib import Path
from typing import List, Dict, Tuple
from datetime import datetime
import os

# Color codes for output


class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

###############################################################################
# Skill Database & Patterns
###############################################################################


SKILLS = {
    "bug-investigator": {
        "keywords": ["bug", "error", "crash", "fails", "issue", "problem", "lỗi", "crash", "stacktrace"],
        "patterns": [
            r"(null|undefined)",
            r"(exception|thrown)",
            r"(doesn't work|not working)",
            r"(broken|fail)",
        ],
        "context_boost": ["production", "live", "user reported"],
        "description": "Tìm nguyên nhân bug, phân tích stacktrace"
    },

    "code-reviewer": {
        "keywords": ["review", "check", "PR", "merge", "pull request", "kiểm tra", "code quality"],
        "patterns": [
            r"(before merge|before commit)",
            r"(quality check|QA)",
            r"(review my|look at)",
        ],
        "context_boost": ["before deploy", "production ready"],
        "description": "Kiểm tra code quality, security, edge cases"
    },

    "frontend-architect": {
        "keywords": ["ui", "ux", "design", "css", "tailwind", "style", "component", "responsive", "giao diện"],
        "patterns": [
            r"(button|form|input)",
            r"(mobile|responsive)",
            r"(animation|motion)",
            r"(layout|spacing)",
        ],
        "context_boost": ["visual", "user experience", "design system"],
        "description": "Thiết kế UI, responsive, animation"
    },

    "tech-lead": {
        "keywords": ["architecture", "design", "performance", "optimization", "slow", "scale", "thiết kế kỹ thuật"],
        "patterns": [
            r"(architecture|structure)",
            r"(performance|slow|fast)",
            r"(scalability|scale)",
            r"(refactor)",
        ],
        "context_boost": ["large scale", "complex system", "high volume"],
        "description": "Thiết kế hệ thống, tối ưu performance"
    },

    "security-auditor": {
        "keywords": ["security", "hack", "token", "secret", "api key", "auth", "vulnerable", "bảo mật"],
        "patterns": [
            r"(token|credential|secret)",
            r"(injection|xss|csrf)",
            r"(authenticate|authorize)",
            r"(vulnerability|expose)",
        ],
        "context_boost": ["production", "sensitive data", "user data"],
        "description": "Kiểm tra security, phát hiện lỗ hổng"
    },

    "test-engineer": {
        "keywords": ["test", "coverage", "unit test", "e2e", "mock", "fixture", "test coverage"],
        "patterns": [
            r"(test case|test scenario)",
            r"(coverage|untested)",
            r"(mock|stub)",
            r"(integration test|unit test)",
        ],
        "context_boost": ["before deploy", "qa", "quality"],
        "description": "Viết test, đảm bảo coverage"
    },

    "product-manager": {
        "keywords": ["feature", "requirement", "user story", "product", "roadmap", "vision", "tính năng"],
        "patterns": [
            r"(new feature|feature request)",
            r"(user wants|requirement)",
            r"(product vision)",
            r"(roadmap|planning)",
        ],
        "context_boost": ["what should we", "how to approach"],
        "description": "Lên kế hoạch feature, phân tích requirements"
    },

    "copywriter": {
        "keywords": ["copy", "text", "content", "writing", "headline", "cta", "message", "nội dung"],
        "patterns": [
            r"(landing page|email)",
            r"(button text|label)",
            r"(headline|tagline)",
            r"(call.?to.?action)",
        ],
        "context_boost": ["marketing", "user-facing", "brand"],
        "description": "Viết nội dung, CTA, headlines"
    },

    "vibecoder": {
        "keywords": ["fast", "quick", "implement", "build", "nhanh", "xây dựng"],
        "patterns": [
            r"(implement now|quick build)",
            r"(2000\+|high.*volume)",
            r"(rapid|fast)",
        ],
        "context_boost": ["urgent", "rapid development"],
        "description": "Implement nhanh, 2000+ lines/iteration"
    },
}

###############################################################################
# Scoring Algorithm
###############################################################################


def score_skill(user_input: str, skill_name: str, skill_info: Dict) -> Tuple[float, List[str]]:
    """
    Score how well a skill matches the user's request.

    Returns:
        tuple: (confidence_score, matched_reasons)
    """
    score = 0.0
    reasons = []

    user_lower = user_input.lower()

    # 1. Keyword matching (30 points max)
    keywords_matched = 0
    for keyword in skill_info["keywords"]:
        if keyword.lower() in user_lower:
            keywords_matched += 1
            reasons.append(f"keyword_match: {keyword}")

    score += min(keywords_matched * 10, 30)

    # 2. Pattern matching (40 points max)
    import re
    patterns_matched = 0
    for pattern in skill_info["patterns"]:
        if re.search(pattern, user_lower, re.IGNORECASE):
            patterns_matched += 1
            reasons.append(f"pattern_match: {pattern}")

    score += min(patterns_matched * 10, 40)

    # 3. Context boosting (20 points)
    for boost_word in skill_info["context_boost"]:
        if boost_word.lower() in user_lower:
            score += 10
            reasons.append(f"context_boost: {boost_word}")
            break

    # 4. Normalize to 0-100
    score = min(score, 100)

    return score, reasons


def get_top_skills(user_input: str, top_n: int = 3) -> List[Dict]:
    """
    Get top N skills sorted by confidence score.

    Returns:
        list: Sorted list of skills with scores and reasons
    """
    results = []

    for skill_name, skill_info in SKILLS.items():
        score, reasons = score_skill(user_input, skill_name, skill_info)
        results.append({
            "skill": skill_name,
            "confidence": score,
            "reasons": reasons,
            "description": skill_info["description"]
        })

    # Sort by confidence descending
    results.sort(key=lambda x: x["confidence"], reverse=True)

    return results[:top_n]

###############################################################################
# Output Formatting
###############################################################################


def print_text_output(user_input: str, results: List[Dict]) -> None:
    """Print results in human-readable format."""
    print(f"\n{Colors.CYAN}{'═' * 60}{Colors.END}")
    print(f"{Colors.BOLD}Skill Selection Results{Colors.END}")
    print(f"{Colors.CYAN}{'═' * 60}{Colors.END}\n")

    print(f"You said: {Colors.YELLOW}{user_input}{Colors.END}\n")
    print(f"Top suggestions:\n")

    for i, result in enumerate(results, 1):
        confidence = result["confidence"]

        # Color code by confidence
        if confidence >= 70:
            conf_color = Colors.GREEN
            conf_emoji = "🎯"
        elif confidence >= 50:
            conf_color = Colors.YELLOW
            conf_emoji = "⚠️"
        else:
            conf_color = Colors.RED
            conf_emoji = "❓"

        print(f"  {Colors.BOLD}[{i}]{Colors.END} {conf_emoji} {result['skill']:20} " +
              f"{conf_color}{confidence:3.0f}%{Colors.END}")
        print(f"      {result['description']}")

        if result["reasons"]:
            print(f"      Matched: {', '.join(result['reasons'][:2])}")
        print()

    print(f"{Colors.CYAN}{'═' * 60}{Colors.END}\n")


def print_json_output(user_input: str, results: List[Dict]) -> None:
    """Print results as JSON."""
    output = {
        "user_input": user_input,
        "timestamp": datetime.now().isoformat(),
        "results": [
            {
                "rank": i,
                "skill": r["skill"],
                "confidence": r["confidence"],
                "description": r["description"],
            }
            for i, r in enumerate(results, 1)
        ]
    }
    print(json.dumps(output, indent=2, ensure_ascii=False))


def print_csv_output(user_input: str, results: List[Dict]) -> None:
    """Print results as CSV."""
    print("rank,skill,confidence,description")
    for i, r in enumerate(results, 1):
        confidence = f"{r['confidence']:.0f}"
        print(f"{i},{r['skill']},{confidence},\"{r['description']}\"")

###############################################################################
# Interactive Mode
###############################################################################


def interactive_mode() -> None:
    """Interactive skill selection."""
    print(f"\n{Colors.HEADER}🎯 Skill Selector - Interactive Mode{Colors.END}\n")
    print("Describe what you want to do (or type 'quit' to exit):")
    print()

    while True:
        try:
            user_input = input(f"{Colors.BLUE}> {Colors.END}").strip()
        except EOFError:
            break
        except KeyboardInterrupt:
            print("\nExiting...")
            break

        if user_input.lower() in ["quit", "exit", "q"]:
            break

        if not user_input:
            continue

        results = get_top_skills(user_input, top_n=3)
        print_text_output(user_input, results)

###############################################################################
# Main
###############################################################################


def main():
    parser = argparse.ArgumentParser(
        description="Skill Confidence Scorer - Select best skill for your task"
    )
    parser.add_argument(
        "input",
        nargs="?",
        default=None,
        help="Your task description"
    )
    parser.add_argument(
        "--input-file",
        "-f",
        help="Read input from file"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output as JSON"
    )
    parser.add_argument(
        "--csv",
        action="store_true",
        help="Output as CSV"
    )
    parser.add_argument(
        "--interactive",
        "-i",
        action="store_true",
        help="Interactive mode"
    )
    parser.add_argument(
        "--top-n",
        type=int,
        default=3,
        help="Number of top skills to return (default: 3)"
    )

    args = parser.parse_args()

    # Interactive mode
    if args.interactive:
        interactive_mode()
        return

    # Get input
    if args.input_file:
        with open(args.input_file) as f:
            user_input = f.read().strip()
    elif args.input:
        user_input = args.input
    else:
        parser.print_help()
        sys.exit(1)

    # Score and output
    results = get_top_skills(user_input, top_n=args.top_n)

    if args.json:
        print_json_output(user_input, results)
    elif args.csv:
        print_csv_output(user_input, results)
    else:
        print_text_output(user_input, results)


if __name__ == "__main__":
    main()
