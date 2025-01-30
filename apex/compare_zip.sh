
#
# Compare Source from Zip File
#
# ./compare_zip.sh" "${ZIP_FILE_ROOT}"
#   1) ${ZIP_FILE_ROOT} - Root name of Zip file (ex. "capture_files")
#

ZIP_FILE_ROOT="${1:-temp_files}"
echo ""

echo "Setup Folder ${ZIP_FILE_ROOT}"
rm -rf "${ZIP_FILE_ROOT}"
mkdir "${ZIP_FILE_ROOT}"

cd "${ZIP_FILE_ROOT}"
echo "Unzip File ../${ZIP_FILE_ROOT}.zip"
unzip "../${ZIP_FILE_ROOT}.zip"
echo "Compare Files from '${PWD}' folders"
ls |
   while read FOLDER
do
   diff -drywtNW 130 --suppress-common-lines "../../../${FOLDER}" "${FOLDER}"
done > "../diff_report.txt" 2>&1
cd ..

echo "Files that are Different"
grep -e '^diff ' "diff_report.txt" | cut '-d ' -f6
