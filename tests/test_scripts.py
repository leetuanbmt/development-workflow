import unittest
from unittest.mock import patch, mock_open, MagicMock
import sys
import os

# Add scripts directory to path to allow import
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../scripts')))

import generate_commands
import link_skills_to_workflows

class TestGenerateCommands(unittest.TestCase):
    def test_parse_frontmatter_valid(self):
        content = """---
description: "Test Description"
skill: "test-skill"
---
Test Body"""
        meta, body = generate_commands.parse_frontmatter(content)
        self.assertEqual(meta["description"], "Test Description")
        self.assertEqual(meta["skill"], "test-skill")
        self.assertEqual(body, "Test Body")

    def test_parse_frontmatter_no_skill(self):
        content = """---
description: "Test Description"
---
Test Body"""
        meta, body = generate_commands.parse_frontmatter(content)
        self.assertEqual(meta["description"], "Test Description")
        self.assertIsNone(meta["skill"])
        self.assertEqual(body, "Test Body")
    
    def test_parse_frontmatter_invalid(self):
        content = "Invalid content"
        meta, body = generate_commands.parse_frontmatter(content)
        self.assertEqual(meta["description"], "AI Workflow Command")
        self.assertEqual(body, "Invalid content")

    @patch('os.makedirs')
    @patch('os.path.exists')
    @patch('glob.glob')
    @patch('builtins.open', new_callable=mock_open)
    def test_convert_md_to_toml(self, mock_file, mock_glob, mock_exists, mock_makedirs):
        # Setup mocks
        mock_exists.return_value = False # Force makedirs to run
        mock_glob.return_value = ['test.md']
        
        md_content = """---
description: "Test"
skill: "test-skill"
---
Prompt content"""
        mock_file.return_value.read.return_value = md_content
        
        # Run function
        generate_commands.convert_md_to_toml()
        
        # Verify
        mock_makedirs.assert_called()
        mock_file.assert_called()
        
        # Verify write content
        handle = mock_file()
        handle.write.assert_called()
        args = handle.write.call_args[0][0]
        self.assertIn('description = "Test"', args)
        self.assertIn('[config.skill]', args)
        self.assertIn('name = "test-skill"', args)
        self.assertIn('prompt = """', args)

class TestLinkSkills(unittest.TestCase):
    @patch('os.path.exists')
    @patch('builtins.open', new_callable=mock_open)
    def test_link_skills_inject(self, mock_file, mock_exists):
        # Setup mocks
        mock_exists.return_value = True
        
        # Original content without skills
        content = """---
description: "Test"
---
Body"""
        mock_file.return_value.read.return_value = content
        
        # Override MAP for testing
        link_skills_to_workflows.WORKFLOW_SKILL_MAP = {
            "test.md": ["skill1", "skill2"]
        }
        
        # Run function
        link_skills_to_workflows.link_skills()
        
        # Verify write
        handle = mock_file()
        handle.write.assert_called()
        args = handle.write.call_args[0][0]
        
        self.assertIn("skills:", args)
        self.assertIn("- skill1", args)
        self.assertIn("- skill2", args)

    @patch('os.path.exists')
    @patch('builtins.open', new_callable=mock_open)
    def test_link_skills_skip_existing(self, mock_file, mock_exists):
        # Setup mocks
        mock_exists.return_value = True
        
        # Content with skills already
        content = """---
description: "Test"
skills:
  - existing
---
Body"""
        mock_file.return_value.read.return_value = content
        
        link_skills_to_workflows.WORKFLOW_SKILL_MAP = {
            "test.md": ["new-skill"]
        }
        
        # Run function
        link_skills_to_workflows.link_skills()
        
        # Only read called, write NOT called
        mock_file.return_value.read.assert_called()
        mock_file.return_value.write.assert_not_called()

if __name__ == '__main__':
    unittest.main()
